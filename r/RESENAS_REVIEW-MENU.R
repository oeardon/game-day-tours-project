####################################################################
# PROYECTO GAME_DAY_TOURS - Menú interactivo CRUD de reseñas
# Requiere: Proyecto_CRUD_Resenas.R con funciones:
#   crear_resena(reserva_id, calificacion, texto, fecha_resena=NULL)
#   leer_resenas(reserva_id=NULL, cliente_id=NULL, fecha_desde=NULL,
#                fecha_hasta=NULL, min_calificacion=NULL, limit=100,
#                ort_desc=TRUE)
#   actualizar_resena(id_resena, calificacion=NULL, texto=NULL,
#                     fecha_resena=NULL)
#   eliminar_resena(id_resena)
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

# 1) Cargar el CRUD
source("Proyecto_CRUD_Resenas.R")

# 2) Utilidades de entrada/validación
quitar_espacios <- function(texto) sub("^\\s+|\\s+$", "", texto)

pedir_texto <- function(mensaje) {
  entrada <- readline(prompt = mensaje)
  quitar_espacios(entrada)
}

pedir_entero <- function(mensaje, permitir_vacio = FALSE) {
  repeat {
    entrada <- pedir_texto(mensaje)
    if (permitir_vacio && entrada == "") return(NA_integer_)
    numero <- suppressWarnings(as.integer(entrada))
    if (!is.na(numero)) return(numero)
    cat("Ingrese un número entero válido.\n")
  }
}

pedir_calificacion <- function(mensaje = "Calificación (1..5): ", permitir_vacio = FALSE) {
  repeat {
    entrada <- pedir_texto(mensaje)
    if (permitir_vacio && entrada == "") return(NA_integer_)
    numero <- suppressWarnings(as.integer(entrada))
    if (!is.na(numero) && numero >= 1 && numero <= 5) return(numero)
    cat("La calificación debe ser un número entero entre 1 y 5.\n")
  }
}

pedir_fecha <- function(mensaje = "Fecha (AAAA-MM-DD HH:MM:SS) vacía=automática: ", permitir_vacio = TRUE) {
  entrada <- pedir_texto(mensaje)
  if (permitir_vacio && entrada == "") return(NA_character_)  # lo interpretaremos como NULL
  
  # Intento flexible: permitir "AAAA-MM-DD" o "AAAA-MM-DD HH:MM:SS"
  formatos_posibles <- c("%Y-%m-%d %H:%M:%S", "%Y-%m-%d")
  for (formato in formatos_posibles) {
    fecha_convertida <- suppressWarnings(as.POSIXct(entrada, format = formato, tz = "UTC"))
    if (!is.na(fecha_convertida)) return(format(fecha_convertida, "%Y-%m-%d %H:%M:%S"))
  }
  cat("Formato de fecha inválido. Ejemplos: 2025-08-22 10:30:00  o  2025-08-22\n")
  return(pedir_fecha(mensaje, permitir_vacio))
}

preguntar_si_no <- function(mensaje = "¿Confirmar? (S/N): ") {
  repeat {
    entrada <- toupper(pedir_texto(mensaje))
    if (entrada %in% c("S","N")) return(entrada == "S")
    cat("Responda S o N.\n")
  }
}

presione_enter <- function() invisible(readline("\n(Presione Enter para continuar)"))

# 3) Operaciones
operacion_crear <- function() {
  cat("\n=== Crear reseña ===\n")
  reserva_id_ingresado   <- pedir_texto("Código de reservación: ")
  calificacion_ingresada <- pedir_calificacion()
  texto_ingresado        <- pedir_texto("Texto de reseña: ")
  fecha_ingresada        <- pedir_fecha("Fecha de reseña (AAAA-MM-DD) vacía=automática: ", permitir_vacio = TRUE)

  fecha_final <- if (is.na(fecha_ingresada)) NULL else fecha_ingresada

  id_nuevo <- tryCatch({
    crear_resena(
      reserva_id   = reserva_id_ingresado,
      calificacion = calificacion_ingresada,
      texto        = texto_ingresado,
      fecha_resena = fecha_final
    )
  }, error = function(e) {
    cat("❌ Error al crear la reseña:", e$message, "\n")
    NULL
  })

  if (!is.null(id_nuevo)) {
    cat("✅ Reseña creada. _id:", id_nuevo, "\n")
  }
  presione_enter()
}

operacion_mostrar <- function() {
  cat("\n=== Mostrar reseñas ===\n")
  cat("Deje vacío lo que no quiera filtrar.\n")
  reserva_id_ingresado   <- pedir_texto("Código de reservación (vacío = no filtrar): ")
  cliente_id_ingresado   <- pedir_texto("ID de cliente (vacío = no filtrar): ")
  calificacion_minima    <- pedir_calificacion("Calificación mínima (1..5, vacío = ninguna): ", permitir_vacio = TRUE)
  fecha_desde_ingresada  <- pedir_fecha("Desde (AAAA-MM-DD[ HH:MM:SS], vacío = ninguna): ", permitir_vacio = TRUE)
  fecha_hasta_ingresada  <- pedir_fecha("Hasta (AAAA-MM-DD[ HH:MM:SS], vacío = ninguna): ", permitir_vacio = TRUE)
  limite_filas_ingresado <- pedir_entero("Límite de filas (ej. 50): ", permitir_vacio = TRUE)

  filtro_reserva   <- if (nchar(reserva_id_ingresado)) reserva_id_ingresado else NULL
  filtro_cliente   <- if (nchar(cliente_id_ingresado)) cliente_id_ingresado else NULL
  filtro_minimo    <- if (!is.na(calificacion_minima)) calificacion_minima else NULL
  filtro_desde     <- if (!is.na(fecha_desde_ingresada)) fecha_desde_ingresada else NULL
  filtro_hasta     <- if (!is.na(fecha_hasta_ingresada)) fecha_hasta_ingresada else NULL
  limite_final     <- if (!is.na(limite_filas_ingresado)) limite_filas_ingresado else 50

  datos_resenas <- tryCatch({
    leer_resenas(
      reserva_id       = filtro_reserva,
      cliente_id       = filtro_cliente,
      fecha_desde      = filtro_desde,
      fecha_hasta      = filtro_hasta,
      min_calificacion = filtro_minimo,
      limit            = limite_final,
      sort_desc        = TRUE
    )
  }, error = function(e) {
    cat("❌ Error al leer reseñas:", e$message, "\n")
    NULL
  })

  if (!is.null(datos_resenas)) {
    print(datos_resenas)
    cat("\nTotal filas:", nrow(datos_resenas), "\n")
  }
  presione_enter()
}

operacion_actualizar <- function() {
  cat("\n=== Actualizar reseña ===\n")
  id_resena_ingresado <- pedir_texto("Ingrese el _id de la reseña: ")
  if (!nchar(id_resena_ingresado)) {
    cat("Debe indicar el _id.\n"); presione_enter(); return(invisible(NULL))
  }

  cat("Deje en blanco para NO cambiar ese campo.\n")
  nueva_calificacion <- pedir_calificacion("Nueva calificación (1..5, vacío = sin cambio): ", permitir_vacio = TRUE)
  nuevo_texto        <- pedir_texto("Nuevo texto (vacío = sin cambio): ")
  nueva_fecha        <- pedir_fecha("Nueva fecha (AAAA-MM-DD[ HH:MM:SS], vacío = sin cambio): ", permitir_vacio = TRUE)

  parametro_calificacion <- if (!is.na(nueva_calificacion)) nueva_calificacion else NULL
  parametro_texto        <- if (nchar(nuevo_texto)) nuevo_texto else NULL
  parametro_fecha        <- if (!is.na(nueva_fecha)) nueva_fecha else NULL

  if (is.null(parametro_calificacion) && is.null(parametro_texto) && is.null(parametro_fecha)) {
    cat("No se especificó ningún cambio.\n"); presione_enter(); return(invisible(NULL))
  }

  resultado_actualizacion <- tryCatch({
    actualizar_resena(
      id_resena    = id_resena_ingresado,
      calificacion = parametro_calificacion,
      texto        = parametro_texto,
      fecha_resena = parametro_fecha
    )
    TRUE
  }, error = function(e) {
    cat("❌ Error al actualizar la reseña:", e$message, "\n")
    FALSE
  })

  if (resultado_actualizacion) cat("✅ Reseña actualizada.\n")
  presione_enter()
}

operacion_borrar <- function() {
  cat("\n=== Borrar reseña ===\n")
  id_resena_ingresado <- pedir_texto("Ingrese el _id de la reseña: ")
  if (!nchar(id_resena_ingresado)) {
    cat("Debe indicar el _id.\n"); presione_enter(); return(invisible(NULL))
    }
  confirmado <- preguntar_si_no("¿Está seguro que desea eliminarla? (S/N): ")
  if (!confirmado) {
    cat("Operación cancelada.\n"); presione_enter(); return(invisible(NULL))
  }

  resultado_borrado <- tryCatch({
    eliminar_resena(id_resena_ingresado)
    TRUE
  }, error = function(e) {
    cat("❌ Error al eliminar la reseña:", e$message, "\n")
    FALSE
  })

  if (resultado_borrado) cat("✅ Reseña eliminada.\n")
  presione_enter()
}

# 4) Menú principal
mostrar_menu <- function() {
  cat("\n================ MENÚ RESEÑAS ================\n")
  cat("1) Crear reseña\n")
  cat("2) Mostrar reseñas\n")
  cat("3) Actualizar reseña\n")
  cat("4) Borrar reseña\n")
  cat("5) Salir\n")
  cat("==============================================\n")
}

ejecutar_menu <- function() {
  repeat {
    mostrar_menu()
    opcion_seleccionada <- pedir_texto("Seleccione una opción (1-5): ")
    if (!nchar(opcion_seleccionada)) next
    if (opcion_seleccionada == "1")      operacion_crear()
    else if (opcion_seleccionada == "2") operacion_mostrar()
    else if (opcion_seleccionada == "3") operacion_actualizar()
    else if (opcion_seleccionada == "4") operacion_borrar()
    else if (opcion_seleccionada == "5") { cat("Hasta luego.\n"); break }
    else cat("Opción inválida.\n")
  }
}

# 5) Ejecutar
ejecutar_menu()