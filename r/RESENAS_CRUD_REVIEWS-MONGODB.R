####################################################################
# PROYECTO GAME_DAY_TOURS - CRUD de RESEÑAS (MongoDB)
# Descripción:
#   - Conecta a MongoDB Atlas (GAME_DAY_TOURS)
#   - CRUD sobre colección RESENA (reseñas de viajes)
#   - Valida que fechaResena > fecha fin de itinerario
#   - Vincula reseña con reserva y cliente (denormaliza datos clave)
####################################################################

paquetes <- c("dplyr", "mongolite", "jsonlite", "lubridate")

for (pkg in paquetes) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)   # Instala si no está disponible
  }
  suppressPackageStartupMessages({
    library(pkg, character.only = TRUE)   # Carga paquete sin mostrar mensajes
  })
}

#### 0) Conexión ####
# Opción directa
MONGO_URI <- Sys.getenv("MONGODB_URI")
### Habilitar acceso a todas las IP temporalmente en Configuración de Atlas ###
# Recomendado: usar variables de entorno (no obligado)
# MONGO_URI <- Sys.getenv("MONGODB_URI")

DB_NAME <- "GAME_DAY_TOURS"

col_reserva    <- mongo(collection = "RESERVACION",    db = DB_NAME, url = MONGO_URI, verbose = FALSE)
col_itinerario <- mongo(collection = "ITINERARIO", db = DB_NAME, url = MONGO_URI, verbose = FALSE)
col_cliente    <- mongo(collection = "CLIENTE",    db = DB_NAME, url = MONGO_URI, verbose = FALSE)
col_resena     <- mongo(collection = "RESENA",     db = DB_NAME, url = MONGO_URI, verbose = FALSE)

# Índices recomendados para RESENA (para búsquedas y reportes)
try(col_resena$index(add = '{"reservaId":1}'),   silent = TRUE)
try(col_resena$index(add = '{"clienteId":1}'),   silent = TRUE)
try(col_resena$index(add = '{"fechaResena":-1}'),silent = TRUE)
try(col_resena$index(add = '{"calificacion":-1}'),silent = TRUE)

#### Utilidad: verificador de ObjectId (24 hex) ####
es_oid24 <- function(x) {
  is.character(x) && nchar(x) == 24 && grepl("^[0-9a-fA-F]{24}$", x)
}

#### 1) Utilidades robustas de búsqueda (nombres y tipos) ####

# Obtiene reserva por ID (acepta ID numérico o string; SOLO por COD_RESERVACION)
get_reserva <- function(reserva_id) {
  entrada <- as.character(reserva_id)
  entrada <- trimws(entrada)
  es_num  <- suppressWarnings(!is.na(as.numeric(entrada)))
  num_val <- if (es_num) as.numeric(entrada) else NA

  lista_consulta <- list()
  if (es_num) lista_consulta <- append(lista_consulta, sprintf('{"COD_RESERVACION": %s}', num_val))
  lista_consulta <- append(lista_consulta, sprintf('{"COD_RESERVACION": "%s"}', entrada))

  for (c in lista_consulta) {
    df <- col_reserva$find(c, limit = 1)
    if (nrow(df) == 1) return(df)
  }
  data.frame()
}

# Obtiene cliente a partir de una fila de reserva (admite COD_CLIENTE/clienteId)
get_cliente_from_reserva <- function(fila_reserva) {
  if (nrow(fila_reserva) == 0) return(data.frame())
  # Posibles nombres
  candidato <- c("COD_CLIENTE","clienteId","codCliente")
  valor <- NA
  for (cnombre in candidato) {
    if (cnombre %in% names(fila_reserva)) {
      valor <- fila_reserva[[cnombre]][1]
      break
    }
  }
  if (is.na(valor)) return(data.frame())

  # Buscar cliente por ID (numérico o string) — sin usar $oid para evitar errores con valores no-OID
  lista_consulta <- list(
    sprintf('{"COD_CLIENTE": %s}', ifelse(suppressWarnings(!is.na(as.numeric(valor))), as.numeric(valor), paste0('"', valor, '"'))),
    sprintf('{"_id": "%s"}',       as.character(valor)),
    sprintf('{"clienteId": "%s"}', as.character(valor))
  )
  for (c in lista_consulta) {
    df <- col_cliente$find(c, limit = 1)
    if (nrow(df) == 1) return(df)
  }
  data.frame()
}

# Obtiene la fecha de fin de itinerario dada la reserva (SOLO por COD_RESERVA)
get_fecha_fin_itinerario <- function(reserva_id) {
  entrada <- as.character(reserva_id)
  entrada <- trimws(entrada)
  es_num  <- suppressWarnings(!is.na(as.numeric(entrada)))
  num_val <- if (es_num) as.numeric(entrada) else NA

  lista_consulta <- list()
  if (es_num) lista_consulta <- append(lista_consulta, sprintf('{"COD_RESERVA": %s}', num_val))
  lista_consulta <- append(lista_consulta, sprintf('{"COD_RESERVA": "%s"}', entrada))

  for (c in lista_consulta) {
    df <- col_itinerario$find(c, fields = '{"_id":0,"FECHA_ENTRADA":1,"fechaEntrada":1}', limit = 1)
    if (nrow(df) == 1) {
      # Normalizar nombre de campo FECHA_ENTRADA / fechaEntrada
      if ("FECHA_ENTRADA" %in% names(df)) return(as_datetime(df$FECHA_ENTRADA[1], tz = "UTC"))
      if ("fechaEntrada"  %in% names(df)) return(as_datetime(df$fechaEntrada[1],  tz = "UTC"))
    }
  }
  # Si no hay itinerario, se devuelve NA (no se podrá crear reseña hasta tenerlo)
  NA
}

#### 2) Validaciones ####

validar_calificacion <- function(calificacion) {
  if (!is.numeric(calificacion)) return("La calificación debe ser numérica (1..5).")
  if (length(calificacion) != 1) return("La calificación debe ser un solo valor.")
  if (is.na(calificacion) || calificacion < 1 || calificacion > 5) return("La calificación debe estar entre 1 y 5.")
  NULL
}

validar_fecha_resena <- function(fecha_resena, reserva_id) {
  fin_iti <- get_fecha_fin_itinerario(reserva_id)
  if (is.na(fin_iti)) {
    return("No se encontró el itinerario (ITINERARIO.COD_RESERVA) para esa reservación; no se puede validar la fecha de reseña.")
  }
  fr <- as_datetime(fecha_resena, tz = "UTC")
  if (is.na(fr)) return("La fecha de reseña no es válida.")
  if (fr <= fin_iti) return(paste0("La fecha de reseña (", fr, ") debe ser posterior a la fecha de fin del itinerario (", fin_iti, ")."))
  NULL
}

#### 3) CREAR RESEÑA ####
# Crea una reseña. Denormaliza datos básicos del cliente para facilitar reportes.
# Parametros:
#   reserva_id   : ID de la reservación (numérico o string) -> RESERVA.COD_RESERVACION
#   calificacion : 1..5
#   texto        : breve reseña
#   fecha_resena : POSIXct/Date/char (se convertirá a ISODate); si es NULL se asigna (fin itinerario + 1 día)
# Return: _id insertado como string (o error)
crear_resena <- function(reserva_id, calificacion, texto, fecha_resena = NULL) {
  # Validar existencia de reserva
  reservacion <- get_reserva(reserva_id)
  if (nrow(reservacion) == 0) stop("La reservación indicada no existe.")

  # Validar calificación
  error <- validar_calificacion(calificacion)
  if (!is.null(error)) stop(error)

  # Obtener cliente (denormalización)
  cliente <- get_cliente_from_reserva(reservacion)
  if (nrow(cliente) == 0) stop("No se encontró el cliente asociado a la reservación.")

  # Determinar fecha de reseña si no se pasa
  if (is.null(fecha_resena)) {
    fin_iti <- get_fecha_fin_itinerario(reserva_id)
    if (is.na(fin_iti)) stop("No se pudo inferir la fecha de reseña porque no existe itinerario.")
    fecha_resena <- fin_iti + days(1)
  }
  # Validar fecha de reseña > fin itinerario
  error <- validar_fecha_resena(fecha_resena, reserva_id)
  if (!is.null(error)) stop(error)

  # Normalizar campos de cliente para guardar (ajusta a tus nombres reales)
  cliente_id <- NA
  cliente_nombre <- NA

  for (candidato in c("COD_CLIENTE","clienteId","_id")) {
    if (candidato %in% names(reservacion)) {
      cliente_id <- as.character(reservacion[[candidato]][1])
      break
    }
  }
  # Si no vino en la reserva, intenta desde el documento cliente
  if (is.na(cliente_id)) {
    for (candidato in c("COD_CLIENTE","clienteId","_id")) {
      if (candidato %in% names(cliente)) {
        cliente_id <- as.character(cliente[[candidato]][1])
        break
      }
    }
  }

  for (candidato in c("NOMBRE_COMPLETO","nombreCompleto","NOMBRE","nombre")) {
    if (candidato %in% names(cliente)) {
      cliente_nombre <- as.character(cliente[[candidato]][1]); break
    }
  }

  # Preparar documento de reseña
  doc <- list(
    reservaId     = as.character(reserva_id),                # guardar como string para evitar fricciones
    clienteId     = unbox(as.character(cliente_id)),
    clienteNombre = unbox(ifelse(is.na(cliente_nombre), "", cliente_nombre)),
    calificacion  = unbox(as.integer(calificacion)),
    texto         = unbox(as.character(texto)),
    fechaResena   = as.POSIXct(fecha_resena, tz = "UTC")     # mongolite convertirá a ISODate
  )

  # Insertar
  res_ins <- col_resena$insert(doc)
  # Para obtener _id, consultamos por (reservaId) descendente y tomamos el último
  doc_id <- NA
  ultimo <- col_resena$find(
    query  = toJSON(list(reservaId = as.character(reserva_id)), auto_unbox = TRUE),
    sort   = '{"_id":-1}',
    fields = '{"_id":1}',
    limit  = 1
  )
  if (nrow(ultimo) == 1 && "_id" %in% names(ultimo)) doc_id <- as.character(ultimo$`_id`)

  invisible(doc_id)
}

#### 4) LECTURA ####
# Lectura flexible:
#   - por reserva_id
#   - por cliente_id
#   - por rango de fechas
#   - por mínima calificación
leer_resenas <- function(reserva_id = NULL, cliente_id = NULL,
                         fecha_desde = NULL, fecha_hasta = NULL,
                         min_calificacion = NULL, limit = 100, sort_desc = TRUE) {

  consulta <- list()
  if (!is.null(reserva_id))  consulta$reservaId    <- as.character(reserva_id)
  if (!is.null(cliente_id))  consulta$clienteId    <- as.character(cliente_id)

  # Filtro por fechas (usa fechaResena como ISODate)
  if (!is.null(fecha_desde) || !is.null(fecha_hasta)) {
    rango <- list()
    if (!is.null(fecha_desde)) rango$`$gte` <- as.POSIXct(fecha_desde, tz = "UTC")
    if (!is.null(fecha_hasta)) rango$`$lte` <- as.POSIXct(fecha_hasta, tz = "UTC")
    consulta$fechaResena <- rango
  }

  if (!is.null(min_calificacion)) {
    consulta$calificacion <- list(`$gte` = as.integer(min_calificacion))
  }

  consulta_json <- toJSON(consulta, auto_unbox = TRUE, POSIXt = "mongo")
  orden <- if (sort_desc) '{"fechaResena":-1}' else '{"fechaResena":1}'
  col_resena$find(query = consulta_json, sort = orden, limit = limit)
}

#### 5) ACTUALIZAR RESEÑA ####
# Actualiza reseña por _id (string). Puedes actualizar calificación, texto y/o fechaResena
actualizar_resena <- function(id_resena, calificacion = NULL, texto = NULL, fecha_resena = NULL) {
  if (is.null(id_resena) || !nchar(id_resena)) stop("id_resena es requerido.")
  if (!es_oid24(id_resena)) stop("El _id de la reseña debe ser un ObjectId de 24 caracteres hexadecimales.")

  # Traer reseña para conocer reservaId y validar fecha si se cambia
  doc_actual <- col_resena$find(
    query  = sprintf('{"_id":{"$oid":"%s"}}', id_resena),
    limit  = 1
  )
  if (nrow(doc_actual) == 0) stop("No existe la reseña indicada.")

  reserva_id <- doc_actual$reservaId[1]

  # Validaciones
  set_list <- list()
  if (!is.null(calificacion)) {
    error <- validar_calificacion(calificacion)
    if (!is.null(error)) stop(error)
    set_list$calificacion <- as.integer(calificacion)
  }
  if (!is.null(texto)) {
    set_list$texto <- as.character(texto)
  }
  if (!is.null(fecha_resena)) {
    error <- validar_fecha_resena(fecha_resena, reserva_id)
    if (!is.null(error)) stop(error)
    set_list$fechaResena <- as.POSIXct(fecha_resena, tz = "UTC")
  }

  if (length(set_list) == 0) stop("No hay cambios para aplicar.")
  update_doc <- toJSON(list(`$set` = set_list), auto_unbox = TRUE, POSIXt = "mongo")

  col_resena$update(
    query  = sprintf('{"_id":{"$oid":"%s"}}', id_resena),
    update = update_doc,
    upsert = FALSE
  )
  invisible(TRUE)
}

#### 6) ELIMINAR RESEÑA ####
eliminar_resena <- function(id_resena) {
  if (is.null(id_resena) || !nchar(id_resena)) stop("id_resena es requerido.")
  if (!es_oid24(id_resena)) stop("El _id de la reseña debe ser un ObjectId de 24 caracteres hexadecimales.")
  col_resena$remove(query = sprintf('{"_id":{"$oid":"%s"}}', id_resena), just_one = TRUE)
  invisible(TRUE)
}
