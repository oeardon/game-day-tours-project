--CREATE DATABASE GAME_DAY_TOURS
USE GAME_DAY_TOURS

CREATE TABLE IDIOMA(
COD_IDIOMA INT,
GUIA_IDIOMA VARCHAR(100)
CONSTRAINT PK_COD_IDIOMA PRIMARY KEY(COD_IDIOMA)
)

CREATE TABLE GUIA(
COD_GUIA INT,
NOMBRE VARCHAR(100),
ESPECIALIDAD VARCHAR(100)
CONSTRAINT PK_COD_GUIA PRIMARY KEY(COD_GUIA)
)

CREATE TABLE HABLA(
COD_IDIOMA INT,
COD_GUIA INT
CONSTRAINT FK_COD_IDIOMA FOREIGN KEY(COD_IDIOMA) REFERENCES IDIOMA(COD_IDIOMA),
CONSTRAINT FK_COD_GUIA FOREIGN KEY(COD_GUIA) REFERENCES GUIA(COD_GUIA)
)

CREATE TABLE CELULAR(
COD_CELULAR INT,
CELULAR INT
CONSTRAINT PK_COD_CELULAR PRIMARY KEY(COD_CELULAR)
)

CREATE TABLE TIPO_IDENTIFICACION(
COD_TIPO_IDENT INT,
TIPO_IDENT VARCHAR(50),
NACIONALIDAD VARCHAR(50)
CONSTRAINT PK_COD_TIPO_IDENT PRIMARY KEY(COD_TIPO_IDENT)
)

CREATE TABLE CATEGORIA(
COD_CAT INT,
NOMBRE VARCHAR(100),
DESCRIPCION VARCHAR(150)
CONSTRAINT PK_COD_CAT PRIMARY KEY(COD_CAT)
)

CREATE TABLE TIPO_ACTIVIDAD(
COD_TIPO_ACTIV INT,
DESCRIPCION VARCHAR(150)
CONSTRAINT PK_COD_TIPO_ACTIV PRIMARY KEY(COD_TIPO_ACTIV)
)

CREATE TABLE PAIS(
COD_PAIS INT,
NOMBRE VARCHAR(20),
LUGAR VARCHAR(150)
CONSTRAINT PK_COD_PAIS PRIMARY KEY(COD_PAIS)
)

CREATE TABLE TIPO_TRANSPORTE(
COD_TIPO_TRANS INT,
TIPO_TRANS VARCHAR(100),
CAPACIDAD INT
CONSTRAINT PK_COD_TIPO_TRANS PRIMARY KEY(COD_TIPO_TRANS)
)

CREATE TABLE PAGO(
COD_PAGO INT,
TIPO_PAGO VARCHAR(100),
MONTO NUMERIC(16,2)
CONSTRAINT PK_COD_PAGO PRIMARY KEY(COD_PAGO)
)

CREATE TABLE TRANSPORTE(
COD_TRANS INT,
MATRICULA VARCHAR(15),
COD_TIPO INT
CONSTRAINT PK_COD_TRANS PRIMARY KEY(COD_TRANS),
CONSTRAINT FK_TRANS_TIPO FOREIGN KEY(COD_TIPO) REFERENCES TIPO_TRANSPORTE(COD_TIPO_TRANS)
)

CREATE TABLE CLIENTE(
COD_CLIENTE INT,
NOMBRE VARCHAR(100),
CORREO VARCHAR(25),
NO_IDENT INT,
COD_TELEFONO INT,
COD_TIPO_IDENT INT
CONSTRAINT PK_COD_CLIENTE PRIMARY KEY(COD_CLIENTE),
CONSTRAINT FK_CLIENTE_TEL FOREIGN KEY(COD_TELEFONO) REFERENCES CELULAR(COD_CELULAR)
)

CREATE TABLE ACTIVIDAD(
COD_ACTIV INT,
NOMBRE VARCHAR(50),
COD_TIPO_ACTIV INT
CONSTRAINT PK_COD_ACTIV PRIMARY KEY(COD_ACTIV),
CONSTRAINT FK_ACTIV_TIPO FOREIGN KEY(COD_TIPO_ACTIV) REFERENCES TIPO_ACTIVIDAD(COD_TIPO_ACTIV)
)

CREATE TABLE DESTINO(
COD_DESTINO INT,
NOMBRE VARCHAR(100),
DESCRIPCION VARCHAR(150),
HOSPEDAJE VARCHAR(100),
RESTAURANTE VARCHAR(50),
COD_CAT INT
CONSTRAINT PK_COD_DESTINO PRIMARY KEY(COD_DESTINO),
CONSTRAINT FK_DESTINO_CAT FOREIGN KEY(COD_CAT) REFERENCES CATEGORIA(COD_CAT)
)

CREATE TABLE VIAJE(
COD_DESTINO INT,
COD_PAIS INT,
CONSTRAINT FK_VIAJE_DEST FOREIGN KEY(COD_DESTINO) REFERENCES DESTINO(COD_DESTINO),
CONSTRAINT FK_VIAJE_PAIS FOREIGN KEY(COD_PAIS) REFERENCES PAIS(COD_PAIS)
)

CREATE TABLE REALIZA(
COD_ACTIV INT,
COD_DESTINO INT
CONSTRAINT FK_REALIZA_ACTIV FOREIGN KEY(COD_ACTIV) REFERENCES ACTIVIDAD(COD_ACTIV),
CONSTRAINT FK_REALIZA_DESTINO FOREIGN KEY(COD_DESTINO) REFERENCES DESTINO(COD_DESTINO)
)

CREATE TABLE RESERVACION(
COD_RESERVACION INT,
CANT_PERSONA INT,
PRECIO NUMERIC(16,2),
FECHA DATE,
COD_CLIENTE INT,
COD_GUIA INT,
COD_PAGO INT,
CONSTRAINT PK_COD_RESERV PRIMARY KEY(COD_RESERVACION),
CONSTRAINT FK_RESERV_CLIENTE FOREIGN KEY(COD_CLIENTE) REFERENCES CLIENTE(COD_CLIENTE),
CONSTRAINT FK_RESERV_GUIA FOREIGN KEY(COD_GUIA) REFERENCES GUIA(COD_GUIA),
CONSTRAINT FK_RESERV_PAGO FOREIGN KEY(COD_PAGO) REFERENCES PAGO(COD_PAGO)
)

CREATE TABLE ITINERARIO(
COD_ITINERARIO INT,
FECHA_SALIDA DATE,
FECHA_ENTRADA DATE,
COD_RESERVA INT,
COD_DESTINO INT
CONSTRAINT PK_COD_ITINE PRIMARY KEY(COD_ITINERARIO),
CONSTRAINT FK_ITINE_RESERVA FOREIGN KEY(COD_RESERVA) REFERENCES RESERVACION(COD_RESERVACION),
CONSTRAINT FK_ITINE_DESTINO FOREIGN KEY(COD_DESTINO) REFERENCES DESTINO(COD_DESTINO)
)

CREATE TABLE ASIGNA(
COD_TRANS INT,
COD_ITINE INT,
CONSTRAINT FK_ASIGNA_TRANS FOREIGN KEY(COD_TRANS) REFERENCES TRANSPORTE(COD_TRANS),
CONSTRAINT FK_ASIGNA_ITINE FOREIGN KEY(COD_ITINE) REFERENCES ITINERARIO(COD_ITINERARIO)
)

ALTER TABLE CLIENTE
ADD CONSTRAINT FK_CLIENTE_IDENT FOREIGN KEY(COD_TIPO_IDENT) REFERENCES TIPO_IDENTIFICACION(COD_TIPO_IDENT)

ALTER TABLE CLIENTE
ALTER COLUMN NO_IDENT VARCHAR(15)

INSERT INTO VIAJE (COD_PAIS,COD_DESTINO) VALUES
(1, 1), (2, 1), (3, 1), (4,1), (5,1);
-- ... (continuar con los 25 viajes)

-- 3. Insertar DESTINOS antes que VIAJES y REALIZA
INSERT INTO DESTINO (COD_DESTINO, NOMBRE, DESCRIPCION, HOSPEDAJE, RESTAURANTE, COD_CAT) VALUES
(2, 'Lago de Atitlán', 'Lago rodeado de volcanes y pueblos indígenas', 'Hotel Atitlán', 'Restaurante 6.8', 3),
(3, 'Tikal', 'Importante sitio arqueológico maya', 'Jungle Lodge', 'Comedor Tikal', 2),
(4, 'Semuc Champey', 'Piscinas naturales de agua turquesa', 'El Retiro Lodge', 'Restaurante Semuc', 1),
(5, 'Volcán Pacaya', 'Volcán activo con senderos para caminata', 'No aplica', 'No aplica', 1),
(6, 'Chichicastenango', 'Famoso mercado indígena', 'Hotel Santo Tomás', 'Comedor Chichicastenango', 2),
(7, 'Río Dulce', 'Río rodeado de selva tropical', 'Hotel Catamarán', 'Restaurante Río', 3),
(8, 'Flores', 'Isla pintoresca en el lago Petén Itzá', 'Hotel Petén', 'Restaurante La Mesa', 4),
(9, 'Quetzaltenango', 'Ciudad en las tierras altas con cultura indígena', 'Hotel Pension Bonifaz', 'Café Baviera', 2),
(10, 'Livingston', 'Pueblo garífuna en el Caribe', 'Hotel Villa Caribe', 'Restaurante Garífuna', 4),
(11, 'Huehuetenango', 'Base para explorar los Cuchumatanes', 'Hotel Zaculeu', 'Comedor Huehue', 1),
(12, 'El Paredón', 'Pueblo playero con olas para surf', 'Driftwood Surfer', 'Restaurante Paredón', 4),
(13, 'Cobán', 'Ciudad de las orquídeas y café', 'Hotel Monja Blanca', 'Café de Cobán', 3),
(14, 'Iximché', 'Ruinas mayas cercanas a Antigua', 'No aplica', 'No aplica', 2),
(15, 'Monterrico', 'Playa de arena negra con tortugas marinas', 'Hotel Johnny´s', 'Restaurante Monterrico', 4),
(16, 'Quiriguá', 'Sitio arqueológico con estelas mayas', 'No aplica', 'No aplica', 2),
(17, 'San Marcos La Laguna', 'Pueblo hippie a orillas del lago', 'Lush Atitlán', 'Restaurante San Marcos', 3),
(18, 'Zacapa', 'Región conocida por su ron y queso', 'Hotel San Antonio', 'Restaurante Zacapa', 3),
(19, 'San Pedro La Laguna', 'Pueblo con vida nocturna junto al lago', 'Hotel San Pedro', 'Restaurante Sublime', 5),
(20, 'El Mirador', 'Remoto sitio maya en la selva', 'Campamento El Mirador', 'Comedor del sitio', 1),
(21, 'Lanquín', 'Pueblo cerca de Semuc Champey', 'Hotel El Recreo', 'Restaurante Lanquín', 1),
(22, 'Panajachel', 'Puerta de entrada al Lago Atitlán', 'Hotel Atitlán', 'Restaurante Pana', 5),
(23, 'San Juan La Laguna', 'Pueblo de artistas y tejedores', 'Hotel San Juan', 'Café Arte', 2),
(24, 'Puerto Barrios', 'Puerto en el Caribe guatemalteco', 'Hotel del Norte', 'Mariscos Puerto', 4);
 
--REALIZA
INSERT INTO REALIZA (COD_ACTIV, COD_DESTINO) VALUES
(1, 5), (2, 3), (3, 1), (4, 2), (5, 2),
(6, 4), (7, 16), (8, 1), (9, 4), (10, 7),
(1, 11), (2, 14), (3, 13), (4, 17), (5, 12),
(6, 21), (7, 3), (8, 9), (9, 20), (10, 4);

-- 6. Insertar ITINERARIOS antes que ASIGNACIONES
INSERT INTO ITINERARIO (COD_ITINERARIO, FECHA_SALIDA, FECHA_ENTRADA, COD_RESERVA, COD_DESTINO) VALUES
(3, '2023-06-05', '2023-06-10', 3, 3),
(4, '2023-06-15', '2023-06-20', 4, 4),
(5, '2023-06-20', '2023-06-25', 5, 5),
(6, '2023-07-05', '2023-07-10', 6, 6),
(7, '2023-07-15', '2023-07-20', 7, 7),
(8, '2023-07-25', '2023-07-30', 8, 8),
(9, '2023-08-10', '2023-08-15', 9, 9);

--RESERVA
INSERT INTO RESERVACION (COD_RESERVACION, CANT_PERSONA, PRECIO, FECHA, COD_CLIENTE, COD_GUIA, COD_PAGO) VALUES
(3, 1, 1200.00, '2023-06-01', 3, 3, 3),
(4, 3, 2000.00, '2023-06-10', 4, 4, 4),
(5, 2, 1800.00, '2023-06-15', 5, 5, 5),
(6, 5, 3500.00, '2023-07-01', 6, 1, 1),
(7, 2, 1600.00, '2023-07-10', 7, 2, 2),
(8, 3, 2200.00, '2023-07-20', 8, 3, 3),
(9, 1, 1100.00, '2023-08-05', 9, 4, 4);
 
 --CLIENTE
 INSERT INTO CLIENTE (COD_CLIENTE, NOMBRE, CORREO, NO_IDENT, COD_TELEFONO, COD_TIPO_IDENT) VALUES
(3, 'John Smith', 'john@email.com', 11223344, 3, 2),
(4, 'María López', 'maria@email.com', 55667788, 4, 1),
(5, 'Pierre Dubois', 'pierre@email.com', 99887766, 5, 2),
(6, 'Ana García', 'ana@email.com', 33445566, 6, 1),
(7, 'Carlos Ramírez', 'carlos@email.com', 77889900, 7, 1),
(8, 'Emma Johnson', 'emma@email.com', 44556677, 8, 2),
(9, 'Luis Martínez', 'luis@email.com', 88990011, 9, 1);
 
 -- 8. Insertar ASIGNACIONES
INSERT INTO ASIGNA (COD_TRANS, COD_ITINE) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(1, 6), (2, 7), (3, 8), (4, 9), (5, 10);

-- Paso 1: Eliminar la restricción existente
ALTER TABLE CLIENTE
DROP CONSTRAINT FK_CLIENTE_TEL;
-- Paso 2: Cambiar el nombre de la columna
EXEC sp_rename 'CLIENTE.COD_TELEFONO', 'COD_CELULAR', 'COLUMN';
-- Paso 3: Volver a crear la restricción con el nuevo nombre
ALTER TABLE CLIENTE
ADD CONSTRAINT FK_CLIENTE_TEL FOREIGN KEY (COD_CELULAR) REFERENCES CELULAR (COD_CELULAR);

SELECT*
FROM CLIENTE
--CLIENTES 2
INSERT INTO CLIENTE(COD_CLIENTE, NOMBRE, CORREO, NO_IDENT, COD_CELULAR, COD_TIPO_IDENT) VALUES---CAMBIAR A TIPO VARCHAR
-- Guatemaltecos (COD_TIPO_IDENT = 1) con DPI de 13 dígitos
(11, 'Andrea Castillo', 'andrea.c@mail.com', 1234567890123, 1, 1),
(12, 'Miguel Solís', 'miguel.s@mail.com', 2345678901234, 2, 1),
(13, 'Patricia Morales', 'patricia.m@mail.com', 3456789012345, 3, 1),
(14, 'Fernanda Juárez', 'fer.j@mail.com', 4567890123456, 4, 1),
(15, 'Ricardo Vargas', 'ricky.v@mail.com', 5678901234567, 5, 1),
(16, 'Isabel Fernández', 'isa.f@mail.com', 6789012345678, 6, 1),
(17, 'Lucía Domínguez', 'lu.d@mail.com', 7890123456789, 7, 1),
(18, 'Alejandro Ruiz', 'alejandro.r@mail.com', 8901234567890, 8, 1),
(19, 'Gabriela Soto', 'gaby.s@mail.com', 9012345678901, 9, 1),
(20, 'Jorge Méndez', 'jorge.m@mail.com', 0123456789012, 10, 1),
-- Extranjeros (COD_TIPO_IDENT = 2) con número de identificación de 8 dígitos
(21, 'David Kim', 'david.k@mail.com', 11223344, 1, 2),
(22, 'Thomas Müller', 'thomas.m@mail.com', 22334455, 2, 2),
(23, 'Oliver Johnson', 'oliver.j@mail.com', 33445566, 3, 2),
(24, 'Giovanni Rossi', 'gio.r@mail.com', 44556677, 4, 2),
(25, 'André Dubois', 'andre.d@mail.com', 55667788, 5, 2),
(26, 'Paul Schmidt', 'paul.s@mail.com', 66778899, 6, 2),
(27, 'Luca Bianchi', 'luca.b@mail.com', 77889900, 7, 2),
-- Guatemaltecos (COD_TIPO_IDENT = 1) con DPI de 13 dígitos
(28, 'Carolina Herrera', 'caro.h@mail.com', 1234567890123, 8, 1),
(29, 'Daniela Castro', 'dani.c@mail.com', 2345678901234, 9, 1),
(30, 'Eduardo Ríos', 'edu.r@mail.com', 3456789012345, 10, 1),
(31, 'Valeria Mendoza', 'vale.m@mail.com', 4567890123456, 1, 1),
(32, 'Ximena López', 'ximena.l@mail.com', 5678901234567, 2, 1),
(33, 'Raúl González', 'raul.g@mail.com', 6789012345678, 3, 1),
(34, 'Camila Sánchez', 'cami.s@mail.com', 7890123456789, 4, 1),
(35, 'Francisco Pérez', 'fran.p@mail.com', 8901234567890, 5, 1),
(36, 'Mariana Gutiérrez', 'mari.g@mail.com', 9012345678901, 6, 1),
(37, 'Sebastián Torres', 'sebas.t@mail.com', 0123456789012, 7, 1),
(38, 'Adriana Flores', 'adri.f@mail.com', 1234567890123, 8, 1),
(39, 'Diego Jiménez', 'diego.j@mail.com', 2345678901234, 9, 1),
(40, 'Natalia Chávez', 'nata.c@mail.com', 3456789012345, 10, 1),
(41, 'Verónica Ramírez', 'vero.r@mail.com', 4567890123456, 1, 1),
(42, 'Oscar Díaz', 'oscar.d@mail.com', 5678901234567, 2, 1),
(43, 'Laura Mejía', 'laura.m@mail.com', 6789012345678, 3, 1),
(44, 'Javier Cordero', 'javier.c@mail.com', 7890123456789, 4, 1),
(45, 'Sara Contreras', 'sara.c@mail.com', 8901234567890, 5, 1),
(46, 'Regina Orellana', 'regina.o@mail.com', 9012345678901, 6, 1),
(47, 'Héctor Barrios', 'hector.b@mail.com', 0123456789012, 7, 1),
(48, 'Diana Arévalo', 'diana.a@mail.com', 1234567890123, 8, 1),
(49, 'Silvia Romero', 'silvia.r@mail.com', 2345678901234, 9, 1),
(50, 'Manuel Vega', 'manuel.v@mail.com', 3456789012345, 10, 1);
 
--BORRAR CACHE
DBCC FREEPROCCACHE;

SELECT*FROM ACTIVIDAD
SELECT*FROM ASIGNA
SELECT*FROM CATEGORIA
SELECT*FROM CELULAR
SELECT*FROM CLIENTE
SELECT*FROM GUIA
SELECT*FROM HABLA
SELECT*FROM IDIOMA
SELECT*FROM ITINERARIO--CONTIENE 3 NULL, AGREGAR
SELECT*FROM PAGO--ELIMINAR LA COLUMNA MONTO
SELECT*FROM REALIZA
SELECT*FROM RESERVACION--AGRAGAR
SELECT*FROM TIPO_ACTIVIDAD
SELECT*FROM TIPO_IDENTIFICACION
SELECT*FROM TIPO_TRANSPORTE
SELECT*FROM TRANSPORTE
SELECT*FROM VIAJE
SELECT*FROM PAIS
SELECT*FROM DESTINO

--VENTAS
SELECT*FROM RESERVACION
SELECT*FROM GUIA
SELECT*FROM CLIENTE
SELECT*FROM PAGO

--1. reservaciones con datos del cliente, guía y forma de pago
SELECT R.COD_RESERVACION, R.CANT_PERSONA, R.PRECIO, R.FECHA, C.NOMBRE AS CLIENTE_NOMBRE,
G.NOMBRE AS GUIA_NOMBRE, P.TIPO_PAGO, P.MONTO
FROM RESERVACION R
JOIN CLIENTE C ON R.COD_CLIENTE = C.COD_CLIENTE
JOIN GUIA G ON R.COD_GUIA = G.COD_GUIA
JOIN PAGO P ON R.COD_PAGO = P.COD_PAGO

--2. total de ingresos por tipo de pago
SELECT P.TIPO_PAGO, SUM(P.MONTO) AS TOTAL_INGRESOS
FROM PAGO P
GROUP BY P.TIPO_PAGO

--3. clientes y la cantidad de reservaciones que han hecho
SELECT C.NOMBRE, COUNT(R.COD_RESERVACION) AS CANTIDAD_RESERVAS
FROM CLIENTE C
LEFT JOIN RESERVACION R ON C.COD_CLIENTE = R.COD_CLIENTE
GROUP BY C.NOMBRE

--4. total recaudado por cada guía en todas sus reservaciones
SELECT G.NOMBRE AS GUIA_NOMBRE, SUM(R.PRECIO) AS TOTAL_RECAUDADO
FROM RESERVACION R
JOIN GUIA G ON R.COD_GUIA = G.COD_GUIA
GROUP BY G.NOMBRE

--5. total de personas que han reservado
SELECT SUM(CANT_PERSONA) AS TOTAL_PERSONAS
FROM RESERVACION

--6. reservacion realizada por cliente (nombre)
SELECT R.COD_RESERVACION, R.FECHA, R.CANT_PERSONA, R.PRECIO
FROM RESERVACION AS R
JOIN CLIENTE C ON R.COD_CLIENTE = C.COD_CLIENTE
WHERE C.NOMBRE LIKE 'Roberto Mendoza'

--7. reservaciones por fecha descendiente
SELECT R.COD_RESERVACION, R.FECHA, R.CANT_PERSONA, R.PRECIO
FROM RESERVACION AS R
ORDER BY R.FECHA DESC

--8. clientes que reservaron con guia especifico (nombre)
SELECT DISTINCT C.NOMBRE AS CLIENTE_NOMBRE
FROM CLIENTE C
JOIN RESERVACION R ON C.COD_CLIENTE = R.COD_CLIENTE
JOIN GUIA G ON R.COD_GUIA = G.COD_GUIA
WHERE G.NOMBRE = 'María González'

--9. monto total pagado por cada cliente (sumando todas sus reservaciones)
SELECT C.NOMBRE AS CLIENTE_NOMBRE, SUM(P.MONTO) AS TOTAL_PAGADO
FROM CLIENTE C
JOIN RESERVACION R ON C.COD_CLIENTE = R.COD_CLIENTE
JOIN PAGO P ON R.COD_PAGO = P.COD_PAGO
GROUP BY C.NOMBRE

--10. clientes que no han hecho reservaciones
SELECT C.NOMBRE
FROM CLIENTE C
LEFT JOIN RESERVACION R ON C.COD_CLIENTE = R.COD_CLIENTE
WHERE R.COD_RESERVACION IS NULL

--11. cantidad de formas de pago realizadas
SELECT P.TIPO_PAGO, COUNT(R.COD_PAGO) AS VECES_USADO
FROM PAGO P
LEFT JOIN RESERVACION R ON P.COD_PAGO = R.COD_PAGO
GROUP BY P.TIPO_PAGO

--LOGISTICA
SELECT*FROM TIPO_TRANSPORTE
SELECT*FROM TRANSPORTE

--1. obtener todos los transportes con su tipo y capacidad
SELECT T.COD_TRANS, T.MATRICULA, TT.TIPO_TRANS, TT.CAPACIDAD
FROM TRANSPORTE T
JOIN TIPO_TRANSPORTE TT ON T.COD_TIPO = TT.COD_TIPO_TRANS

--2. contar cuántos transportes hay por tipo
SELECT TT.TIPO_TRANS, COUNT(*) AS TOTAL_TRANSPORTES
FROM TRANSPORTE T
JOIN TIPO_TRANSPORTE TT ON T.COD_TIPO = TT.COD_TIPO_TRANS
GROUP BY TT.TIPO_TRANS

--3. mostrar la matrícula y tipo de transporte de todos los transportes con capacidad mayor a 15
SELECT T.MATRICULA, TT.TIPO_TRANS, TT.CAPACIDAD
FROM TRANSPORTE T
JOIN TIPO_TRANSPORTE TT ON T.COD_TIPO = TT.COD_TIPO_TRANS
WHERE TT.CAPACIDAD > 15

--4. total de transportes registrados
SELECT COUNT(*) AS TOTAL_TRANSPORTES
FROM TRANSPORTE

--5. tipos de transporte junto con su capacidad y la cantidad de transportes asociados
SELECT TT.TIPO_TRANS, TT.CAPACIDAD, COUNT(T.COD_TRANS) AS CANTIDAD_TRANSPORTES
FROM TIPO_TRANSPORTE TT
LEFT JOIN TRANSPORTE T ON TT.COD_TIPO_TRANS = T.COD_TIPO
GROUP BY TT.TIPO_TRANS, TT.CAPACIDAD

--6. vehiculo con mayor capacidad
SELECT T.MATRICULA, TT.TIPO_TRANS, TT.CAPACIDAD
FROM TRANSPORTE T
JOIN TIPO_TRANSPORTE TT ON T.COD_TIPO = TT.COD_TIPO_TRANS
WHERE TT.CAPACIDAD = (SELECT MAX(CAPACIDAD) FROM TIPO_TRANSPORTE)

--7. vehiculo con menor capacidad
SELECT T.MATRICULA, TT.TIPO_TRANS, TT.CAPACIDAD
FROM TRANSPORTE T
JOIN TIPO_TRANSPORTE TT ON T.COD_TIPO = TT.COD_TIPO_TRANS
WHERE TT.CAPACIDAD = (SELECT MIN(CAPACIDAD) FROM TIPO_TRANSPORTE)

--MARCO--
SELECT  R.CANT_PERSONA, R.PRECIO, R.COD_CLIENTE,C.NOMBRE AS NOMBRE_CLIENTE,R.COD_GUIA,G.NOMBRE AS NOMBRE_GUIA, R.COD_PAGO, I.FECHA_ENTRADA, I.FECHA_SALIDA,D.COD_DESTINO, D.NOMBRE AS DESTINO,COD_CAT, R.FECHA AS FECHA_RESERVACION
FROM RESERVACION R
INNER JOIN CLIENTE C ON C.COD_CLIENTE = R.COD_CLIENTE
INNER JOIN GUIA G ON G.COD_GUIA = R.COD_GUIA
INNER JOIN ITINERARIO I ON I.COD_RESERVA = R.COD_RESERVACION
INNER JOIN DESTINO D ON D.COD_DESTINO = I.COD_RESERVA

SELECT TR.TIPO_TRANS, R.COD_RESERVACION, R.CANT_PERSONA,TR.CAPACIDAD, C.COD_CLIENTE, ROUND((CAST(CANT_PERSONA AS FLOAT) / CAST(CAPACIDAD AS FLOAT)) * 100, 2) AS PORCENTAJE_USADO
FROM TIPO_TRANSPORTE TR
INNER JOIN TRANSPORTE T ON T.COD_TRANS = TR.COD_TIPO_TRANS
INNER JOIN ASIGNA A ON A.COD_ITINE  = T.COD_TRANS
INNER JOIN ITINERARIO I ON I.COD_ITINERARIO = A.COD_ITINE
INNER JOIN RESERVACION R ON R.COD_RESERVACION = I.COD_RESERVA
INNER JOIN CLIENTE C ON C.COD_CLIENTE = R.COD_CLIENTE

------------------------------------------------------------------------------
--INSERTAMOS NUMEROS DEL 11 AL 100
DECLARE @i INT = 11;
DECLARE @telefono VARCHAR(8);
WHILE @i <= 100
BEGIN
    SET @telefono = CAST(CAST(RAND(CHECKSUM(NEWID())) * 89999999 + 10000000 AS INT) AS VARCHAR(8));
    INSERT INTO CELULAR (COD_CELULAR, CELULAR)
    VALUES (@i, @telefono);
    SET @i = @i + 1;
END;

--INSERTAMOS 50 CLIENTES MAS
INSERT INTO CLIENTE (COD_CLIENTE, NOMBRE, CORREO, NO_IDENT, COD_CELULAR, COD_TIPO_IDENT)
VALUES
(51, 'Mateo Álvarez', 'mateoalvarez@email.com', '1234567890123', 11, 1),
(52, 'Julieta Rivas', 'julietarivas@email.com', '2345678901234', 12, 2),
(53, 'Iván Cabrera', 'ivancabrera@email.com', '3456789012345', 13, 1),
(54, 'Camila Rojas', 'camilarojas@email.com', '4567890123456', 14, 2),
(55, 'Santiago Peña', 'santiagopena@email.com', '5678901234567', 15, 1),
(56, 'Renata Cruz', 'renatacruz@email.com', '6789012345678', 16, 2),
(57, 'Elena Navarro', 'elenanavarro@email.com', '7890123456789', 17, 1),
(58, 'Lucas Herrera', 'lucasherrera@email.com', '8901234567890', 18, 2),
(59, 'Daniela Salas', 'danielasalas@email.com', '9012345678901', 19, 1),
(60, 'Bruno Medina', 'brunomedina@email.com', '1123456789012', 20, 2),
(61, 'Victoria Roldán', 'victoriaroldan@email.com', '2234567890123', 21, 1),
(62, 'Emilio Vargas', 'emiliovargas@email.com', '3345678901234', 22, 2),
(63, 'Paula Molina', 'paulamolina@email.com', '4456789012345', 23, 1),
(64, 'Maximiliano Soto', 'maxsoto@email.com', '5567890123456', 24, 2),
(65, 'Alma Paredes', 'almaparedes@email.com', '6678901234567', 25, 1),
(66, 'Leonardo Acosta', 'leoacosta@email.com', '7789012345678', 26, 2),
(67, 'Martina Campos', 'martinacampos@email.com', '8890123456789', 27, 1),
(68, 'Ángel Figueroa', 'angelfigueroa@email.com', '9901234567890', 28, 2),
(69, 'Isabella León', 'isabellaleon@email.com', '1012345678901', 29, 1),
(70, 'Thiago Benítez', 'thiagobenitez@email.com', '2123456789012', 30, 2),
(71, 'Marcos Aguirre', 'marcosaguirre@email.com', '3234567890123', 31, 1),
(72, 'Julia Carrillo', 'juliacarrillo@email.com', '4345678901234', 32, 2),
(73, 'Felipe Esquivel', 'felipeesquivel@email.com', '5456789012345', 33, 1),
(74, 'Zoe Lozano', 'zoelozano@email.com', '6567890123456', 34, 2),
(75, 'Benjamín Palma', 'benjaminpalma@email.com', '7678901234567', 35, 1),
(76, 'Valentina Beltrán', 'valentinabelt@email.com', '8789012345678', 36, 2),
(77, 'Diego Farías', 'diegofarias@email.com', '9890123456789', 37, 1),
(78, 'Nicole Ponce', 'nicoleponce@email.com', '9912345678901', 38, 2),
(79, 'Gabriel Aranda', 'gabrielaranda@email.com', '1023456789012', 39, 1),
(80, 'Josefa Núñez', 'josefanunez@email.com', '2134567890123', 40, 2),
(81, 'Sebastián Silva', 'sebastiansilva@email.com', '3245678901234', 41, 1),
(82, 'Agustina Méndez', 'agustinamendez@email.com', '4356789012345', 42, 2),
(83, 'Rodrigo Ibáñez', 'rodrigoibanez@email.com', '5467890123456', 43, 1),
(84, 'Antonia Del Valle', 'antoniadv@email.com', '6578901234567', 44, 2),
(85, 'Tomás Reyes', 'tomasreyes@email.com', '7689012345678', 45, 1),
(86, 'Maite Quiroz', 'maitequiroz@email.com', '8790123456789', 46, 2),
(87, 'Ignacio Bravo', 'ignaciobravo@email.com', '9901234567890', 47, 1),
(88, 'Catalina Pizarro', 'catalipizarro@email.com', '1012345678901', 48, 2),
(89, 'Facundo Bustos', 'facundobustos@email.com', '2123456789012', 49, 1),
(90, 'Renzo Toledo', 'renzotoledo@email.com', '3234567890123', 50, 2),
(91, 'Ariana Salazar', 'arianasalazar@email.com', '4345678901234', 51, 1),
(92, 'Axel Carranza', 'axelcarranza@email.com', '5456789012345', 52, 2),
(93, 'Florencia Mena', 'florenciamena@email.com', '6567890123456', 53, 1),
(94, 'Gael Valdés', 'gaelvaldes@email.com', '7678901234567', 54, 2),
(95, 'Mía Espinoza', 'miaespinoza@email.com', '8789012345678', 55, 1),
(96, 'Ian Zúñiga', 'ianzuniga@email.com', '9890123456789', 56, 2),
(97, 'Bianca Tapia', 'biancatapia@email.com', '9912345678901', 57, 1),
(98, 'Damián Rivera', 'damianrivera@email.com', '1023456789012', 58, 2),
(99, 'Ambar Vera', 'ambarvera@email.com', '2134567890123', 59, 1),
(100, 'Esteban Mora', 'estebanmora@email.com', '3245678901234', 60, 2);


-- Insertar 10 nuevos registros en la tabla guia
INSERT INTO guia (COD_GUIA, NOMBRE, ESPECIALIDAD)
VALUES
    (6, 'Pedro Hernández', 'Geología'),
    (7, 'Laura Sánchez', 'Antropología'),
    (8, 'Ricardo Torres', 'Turismo Rural'),
    (9, 'Elena García', 'Historia Maya'),
    (10, 'Javier Martínez', 'Arte Indígena'),
    (11, 'Sofía Ramírez', 'Biodiversidad'),
    (12, 'Daniel López', 'Turismo Responsable'),
    (13, 'Isabel González', 'Cultura Popol Vuh'),
    (14, 'Andrés Pérez', 'Historia Moderna'),
    (15, 'María Ruiz', 'Turismo Gastronómico');

-------RESERVACION
DECLARE @MaxID INT;
 
-- Obtener el último COD_RESERVACION + 1

SELECT @MaxID = ISNULL(MAX(COD_RESERVACION), 0) + 1 FROM RESERVACION;
 
-- Insertar registros en la tabla RESERVACION (incluyendo COD_RESERVACION)

WITH FechasBase AS (
    SELECT TOP (DATEDIFF(DAY, '2024-01-01', '2025-12-31') + 1)
        Fecha = DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1, '2024-01-01')
    FROM sys.all_objects a, sys.all_objects b
),
FechasLunes AS (
    SELECT 
        DATEADD(DAY, -(DATEPART(WEEKDAY, Fecha) + 5) % 7, Fecha) AS FechaLunes
    FROM FechasBase
    WHERE DATEPART(WEEKDAY, Fecha) BETWEEN 2 AND 6 -- Solo días de semana (lunes a viernes)
    GROUP BY DATEADD(DAY, -(DATEPART(WEEKDAY, Fecha) + 5) % 7, Fecha) -- Agrupar por lunes para evitar duplicados
)
INSERT INTO RESERVACION (COD_RESERVACION, CANT_PERSONA, PRECIO, FECHA, COD_CLIENTE, COD_GUIA, COD_PAGO)
SELECT
    @MaxID + ROW_NUMBER() OVER (ORDER BY F.FechaLunes) AS COD_RESERVACION,
    CANT_PERSONA,
    CAST((200 + RAND(CHECKSUM(NEWID())) * 200) * CANT_PERSONA AS NUMERIC(16, 2)) AS PRECIO,
    F.FechaLunes AS Fecha,
    ABS(CHECKSUM(NEWID())) % 100 + 1 AS COD_CLIENTE,
    ABS(CHECKSUM(NEWID())) % 15 + 1 AS COD_GUIA,
    ABS(CHECKSUM(NEWID())) % 5 + 1 AS COD_PAGO
FROM (
    SELECT
        ABS(CHECKSUM(NEWID())) % 25 + 1 AS CANT_PERSONA,
        F.FechaLunes
    FROM FechasLunes F
    CROSS JOIN (VALUES (1), (2)) AS X(id) -- Corrección aquí: usar alias correcto
) F;
 
 ------ITINERARIO---QUITA NULL
 WITH CTE_Duplicados AS (
    SELECT 
        COD_ITINERARIO,
        COD_RESERVA,
        ROW_NUMBER() OVER (
            PARTITION BY COD_RESERVA 
            ORDER BY COD_ITINERARIO -- Puedes cambiar por FECHA_SALIDA si prefieres
        ) AS rn
FROM ITINERARIO
)
DELETE FROM ITINERARIO
WHERE COD_ITINERARIO IN (
SELECT COD_ITINERARIO
FROM CTE_Duplicados
WHERE rn > 1);

-----ITINERARIO
WITH CTE AS (
    SELECT 
        i.COD_ITINERARIO,
        i.COD_RESERVA,
        ROW_NUMBER() OVER (ORDER BY i.COD_ITINERARIO) + 10 AS Nuevo_COD_RESERVA
    FROM ITINERARIO i
    WHERE i.COD_ITINERARIO BETWEEN 11 AND 250
)
UPDATE CTE
SET COD_RESERVA = Nuevo_COD_RESERVA
WHERE Nuevo_COD_RESERVA IN (SELECT COD_RESERVACION FROM RESERVACION);

----INSERTAR ITINERARIO
INSERT INTO ITINERARIO (COD_ITINERARIO, FECHA_SALIDA, FECHA_ENTRADA, COD_RESERVA, COD_DESTINO) VALUES
(11, '2024-01-04', '2024-01-09', 1, 1),
(12, '2024-01-04', '2024-01-09', 2, 2),
(13, '2024-01-11', '2024-01-16', 3, 3),
(14, '2024-01-18', '2024-01-23', 4, 4),
(15, '2024-01-25', '2024-01-30', 5, 5),
(16, '2024-02-01', '2024-02-06', 6, 6),
(17, '2024-02-01', '2024-02-06', 7, 7),
(18, '2024-02-08', '2024-02-13', 8, 8),
(19, '2024-02-15', '2024-02-20', 9, 9),
(20, '2024-02-22', '2024-02-27', 10, 10),
(21, '2024-02-29', '2024-03-05', 1, 1),
(22, '2024-03-07', '2024-03-12', 2, 2),
(23, '2024-03-07', '2024-03-12', 3, 3),
(24, '2024-03-14', '2024-03-19', 4, 4),
(25, '2024-03-21', '2024-03-26', 5, 5),
(26, '2024-03-28', '2024-04-02', 6, 6),
(27, '2024-04-04', '2024-04-09', 7, 7),
(28, '2024-04-04', '2024-04-09', 8, 8),
(29, '2024-04-11', '2024-04-16', 9, 9),
(30, '2024-04-18', '2024-04-23', 10, 10),
(31, '2024-04-25', '2024-04-30', 1, 1),
(32, '2024-05-02', '2024-05-07', 2, 2),
(33, '2024-05-09', '2024-05-14', 3, 3),
(34, '2024-05-09', '2024-05-14', 4, 4),
(35, '2024-05-16', '2024-05-21', 5, 5),
(36, '2024-05-23', '2024-05-28', 6, 6),
(37, '2024-05-30', '2024-06-04', 7, 7),
(38, '2024-06-06', '2024-06-11', 8, 8),
(39, '2024-06-06', '2024-06-11', 9, 9),
(40, '2024-06-13', '2024-06-18', 10, 10),
(41, '2024-06-20', '2024-06-25', 1, 1),
(42, '2024-06-27', '2024-07-02', 2, 2),
(43, '2024-07-04', '2024-07-09', 3, 3),
(44, '2024-07-04', '2024-07-09', 4, 4),
(45, '2024-07-11', '2024-07-16', 5, 5),
(46, '2024-07-18', '2024-07-23', 6, 6),
(47, '2024-07-25', '2024-07-30', 7, 7),
(48, '2024-08-01', '2024-08-06', 8, 8),
(49, '2024-08-01', '2024-08-06', 9, 9),
(50, '2024-08-08', '2024-08-13', 10, 10),
(51, '2024-08-15', '2024-08-20', 1, 1),
(52, '2024-08-22', '2024-08-27', 2, 2),
(53, '2024-08-29', '2024-09-03', 3, 3),
(54, '2024-08-29', '2024-09-03', 4, 4),
(55, '2024-09-05', '2024-09-10', 5, 5),
(56, '2024-09-12', '2024-09-17', 6, 6),
(57, '2024-09-19', '2024-09-24', 7, 7),
(58, '2024-09-26', '2024-10-01', 8, 8),
(59, '2024-09-26', '2024-10-01', 9, 9),
(60, '2024-10-03', '2024-10-08', 10, 10),
(61, '2024-10-10', '2024-10-15', 1, 1),
(62, '2024-10-17', '2024-10-22', 2, 2),
(63, '2024-10-24', '2024-10-29', 3, 3),
(64, '2024-10-24', '2024-10-29', 4, 4),
(65, '2024-10-31', '2024-11-05', 5, 5),
(66, '2024-11-07', '2024-11-12', 6, 6),
(67, '2024-11-14', '2024-11-19', 7, 7),
(68, '2024-11-21', '2024-11-26', 8, 8),
(69, '2024-11-21', '2024-11-26', 9, 9),
(70, '2024-11-28', '2024-12-03', 10, 10),
(71, '2024-12-05', '2024-12-10', 1, 1),
(72, '2024-12-12', '2024-12-17', 2, 2),
(73, '2024-12-19', '2024-12-24', 3, 3),
(74, '2024-12-19', '2024-12-24', 4, 4),
(75, '2024-12-26', '2024-12-31', 5, 5),
(76, '2025-01-02', '2025-01-07', 6, 6),
(77, '2025-01-09', '2025-01-14', 7, 7),
(78, '2025-01-16', '2025-01-21', 8, 8),
(79, '2025-01-16', '2025-01-21', 9, 9),
(80, '2025-01-23', '2025-01-28', 10, 10),
(81, '2025-01-30', '2025-02-04', 1, 1),
(82, '2025-02-06', '2025-02-11', 2, 2),
(83, '2025-02-13', '2025-02-18', 3, 3),
(84, '2025-02-13', '2025-02-18', 4, 4),
(85, '2025-02-20', '2025-02-25', 5, 5),
(86, '2025-02-27', '2025-03-04', 6, 6),
(87, '2025-03-06', '2025-03-11', 7, 7),
(88, '2025-03-13', '2025-03-18', 8, 8),
(89, '2025-03-13', '2025-03-18', 9, 9),
(90, '2025-03-20', '2025-03-25', 10, 10),
(91, '2025-03-27', '2025-04-01', 1, 1),
(92, '2025-04-03', '2025-04-08', 2, 2),
(93, '2025-04-10', '2025-04-15', 3, 3),
(94, '2025-04-10', '2025-04-15', 4, 4),
(95, '2025-04-17', '2025-04-22', 5, 5),
(96, '2025-04-24', '2025-04-29', 6, 6),
(97, '2025-05-01', '2025-05-06', 7, 7),
(98, '2025-05-08', '2025-05-13', 8, 8),
(99, '2025-05-08', '2025-05-13', 9, 9),
(100, '2025-05-15', '2025-05-20', 10, 10),
(101, '2025-05-22', '2025-05-27', 1, 1),
(102, '2025-05-29', '2025-06-03', 2, 2),
(103, '2025-06-05', '2025-06-10', 3, 3),
(104, '2025-06-05', '2025-06-10', 4, 4),
(105, '2025-06-12', '2025-06-17', 5, 5),
(106, '2025-06-19', '2025-06-24', 6, 6),
(107, '2025-06-26', '2025-07-01', 7, 7),
(108, '2025-07-03', '2025-07-08', 8, 8),
(109, '2025-07-03', '2025-07-08', 9, 9),
(110, '2025-07-10', '2025-07-15', 10, 10),
(111, '2025-07-17', '2025-07-22', 1, 1),
(112, '2025-07-24', '2025-07-29', 2, 2),
(113, '2025-07-31', '2025-08-05', 3, 3),
(114, '2025-07-31', '2025-08-05', 4, 4),
(115, '2025-08-07', '2025-08-12', 5, 5),
(116, '2025-08-14', '2025-08-19', 6, 6),
(117, '2025-08-21', '2025-08-26', 7, 7),
(118, '2025-08-28', '2025-09-02', 8, 8),
(119, '2025-08-28', '2025-09-02', 9, 9),
(120, '2025-09-04', '2025-09-09', 10, 10),
(121, '2025-09-11', '2025-09-16', 1, 1),
(122, '2025-09-18', '2025-09-23', 2, 2),
(123, '2025-09-25', '2025-09-30', 3, 3),
(124, '2025-09-25', '2025-09-30', 4, 4),
(125, '2025-10-02', '2025-10-07', 5, 5),
(126, '2025-10-09', '2025-10-14', 6, 6),
(127, '2025-10-16', '2025-10-21', 7, 7),
(128, '2025-10-23', '2025-10-28', 8, 8),
(129, '2025-10-23', '2025-10-28', 9, 9),
(130, '2025-10-30', '2025-11-04', 10, 10),
(131, '2025-11-06', '2025-11-11', 1, 1),
(132, '2025-11-13', '2025-11-18', 2, 2),
(133, '2025-11-20', '2025-11-25', 3, 3),
(134, '2025-11-20', '2025-11-25', 4, 4),
(135, '2025-11-27', '2025-12-02', 5, 5),
(136, '2025-12-04', '2025-12-09', 6, 6),
(137, '2025-12-11', '2025-12-16', 7, 7),
(138, '2025-12-18', '2025-12-23', 8, 8),
(139, '2025-12-18', '2025-12-23', 9, 9),
(140, '2025-12-25', '2025-12-30', 10, 10),
(141, '2026-01-01', '2026-01-06', 1, 1),
(142, '2026-01-08', '2026-01-13', 2, 2),
(143, '2026-01-15', '2026-01-20', 3, 3),
(144, '2026-01-15', '2026-01-20', 4, 4),
(145, '2026-01-22', '2026-01-27', 5, 5),
(146, '2026-01-29', '2026-02-03', 6, 6),
(147, '2026-02-05', '2026-02-10', 7, 7),
(148, '2026-02-12', '2026-02-17', 8, 8),
(149, '2026-02-12', '2026-02-17', 9, 9),
(150, '2026-02-19', '2026-02-24', 10, 10),
(151, '2026-02-26', '2026-03-03', 1, 1),
(152, '2026-03-05', '2026-03-10', 2, 2),
(153, '2026-03-12', '2026-03-17', 3, 3),
(154, '2026-03-12', '2026-03-17', 4, 4),
(155, '2026-03-19', '2026-03-24', 5, 5),
(156, '2026-03-26', '2026-03-31', 6, 6),
(157, '2026-04-02', '2026-04-07', 7, 7),
(158, '2026-04-09', '2026-04-14', 8, 8),
(159, '2026-04-09', '2026-04-14', 9, 9),
(160, '2026-04-16', '2026-04-21', 10, 10),
(161, '2026-04-23', '2026-04-28', 1, 1),
(162, '2026-04-30', '2026-05-05', 2, 2),
(163, '2026-05-07', '2026-05-12', 3, 3),
(164, '2026-05-07', '2026-05-12', 4, 4),
(165, '2026-05-14', '2026-05-19', 5, 5),
(166, '2026-05-21', '2026-05-26', 6, 6),
(167, '2026-05-28', '2026-06-02', 7, 7),
(168, '2026-06-04', '2026-06-09', 8, 8),
(169, '2026-06-04', '2026-06-09', 9, 9),
(170, '2026-06-11', '2026-06-16', 10, 10),
(171, '2026-06-18', '2026-06-23', 1, 1),
(172, '2026-06-25', '2026-06-30', 2, 2),
(173, '2026-07-02', '2026-07-07', 3, 3),
(174, '2026-07-02', '2026-07-07', 4, 4),
(175, '2026-07-09', '2026-07-14', 5, 5),
(176, '2026-07-16', '2026-07-21', 6, 6),
(177, '2026-07-23', '2026-07-28', 7, 7),
(178, '2026-07-30', '2026-08-04', 8, 8),
(179, '2026-07-30', '2026-08-04', 9, 9),
(180, '2026-08-06', '2026-08-11', 10, 10),
(181, '2026-08-13', '2026-08-18', 1, 1),
(182, '2026-08-20', '2026-08-25', 2, 2),
(183, '2026-08-27', '2026-09-01', 3, 3),
(184, '2026-08-27', '2026-09-01', 4, 4),
(185, '2026-09-03', '2026-09-08', 5, 5),
(186, '2026-09-10', '2026-09-15', 6, 6),
(187, '2026-09-17', '2026-09-22', 7, 7),
(188, '2026-09-24', '2026-09-29', 8, 8),
(189, '2026-09-24', '2026-09-29', 9, 9),
(190, '2026-10-01', '2026-10-06', 10, 10),
(191, '2026-10-08', '2026-10-13', 1, 1),
(192, '2026-10-15', '2026-10-20', 2, 2),
(193, '2026-10-22', '2026-10-27', 3, 3),
(194, '2026-10-22', '2026-10-27', 4, 4),
(195, '2026-10-29', '2026-11-03', 5, 5),
(196, '2026-11-06', '2026-11-11', 6, 6),
(197, '2026-11-13', '2026-11-18', 7, 7),
(198, '2026-11-20', '2026-11-25', 8, 8),
(199, '2026-11-20', '2026-11-25', 9, 9),
(200, '2026-11-27', '2026-12-02', 10, 10),
(201, '2026-12-04', '2026-12-09', 1, 1),
(202, '2026-12-11', '2026-12-16', 2, 2),
(203, '2026-12-18', '2026-12-23', 3, 3),
(204, '2026-12-18', '2026-12-23', 4, 4),
(205, '2026-12-25', '2026-12-30', 5, 5),
(206, '2027-01-01', '2027-01-06', 6, 6),
(207, '2027-01-07', '2027-01-12', 7, 7),
(208, '2027-01-14', '2027-01-19', 8, 8),
(209, '2027-01-14', '2027-01-19', 9, 9),
(210, '2027-01-21', '2027-01-26', 10, 10),
(211, '2027-01-28', '2027-02-02', 1, 1),
(212, '2027-02-04', '2027-02-09', 2, 2),
(213, '2027-02-11', '2027-02-16', 3, 3),
(214, '2027-02-11', '2027-02-16', 4, 4),
(215, '2027-02-18', '2027-02-23', 5, 5),
(216, '2027-02-25', '2027-03-02', 6, 6),
(217, '2027-03-04', '2027-03-09', 7, 7),
(218, '2027-03-11', '2027-03-16', 8, 8),
(219, '2027-03-11', '2027-03-16', 9, 9),
(220, '2027-03-18', '2027-03-23', 10, 10),
(221, '2027-03-25', '2027-03-30', 1, 1),
(222, '2027-04-01', '2027-04-06', 2, 2),
(223, '2027-04-08', '2027-04-13', 3, 3),
(224, '2027-04-08', '2027-04-13', 4, 4),
(225, '2027-04-15', '2027-04-20', 5, 5),
(226, '2027-04-22', '2027-04-27', 6, 6),
(227, '2027-04-29', '2027-05-04', 7, 7),
(228, '2027-05-06', '2027-05-11', 8, 8),
(229, '2027-05-06', '2027-05-11', 9, 9),
(230, '2027-05-13', '2027-05-18', 10, 10),
(231, '2027-05-20', '2027-05-25', 1, 1),
(232, '2027-05-27', '2027-06-01', 2, 2),
(233, '2027-06-03', '2027-06-08', 3, 3),
(234, '2027-06-03', '2027-06-08', 4, 4),
(235, '2027-06-10', '2027-06-15', 5, 5),
(236, '2027-06-17', '2027-06-22', 6, 6),
(237, '2027-06-24', '2027-06-29', 7, 7),
(238, '2027-07-01', '2027-07-06', 8, 8),
(239, '2027-07-01', '2027-07-06', 9, 9),
(240, '2027-07-08', '2027-07-13', 10, 10);

---QUITAR NULL DE ITINERARIO
DELETE FROM ITINERARIO
WHERE 
    ID_ITINERARIO IS NULL OR
    ID_VIAJE IS NULL OR
    DIA IS NULL OR
    ACTIVIDAD IS NULL OR
    HORA_INICIO IS NULL OR
    HORA_FIN IS NULL;
--------------------------------------------

SELECT 
    I.COD_ITINERARIO,
    I.COD_RESERVA,
    I.FECHA_SALIDA AS SALIDA_ACTUAL,
    DATEADD(DAY, 3, R.FECHA) AS SALIDA_CORRECTA,
    I.FECHA_ENTRADA AS ENTRADA_ACTUAL,
    DATEADD(DAY, 6, R.FECHA) AS ENTRADA_CORRECTA
FROM 
    Itinerario I
INNER JOIN 
    Reservacion R ON I.COD_RESERVA = R.COD_RESERVACION;
-------------------------
UPDATE I
SET 
    FECHA_SALIDA = DATEADD(DAY, 3, R.FECHA),
    FECHA_ENTRADA = DATEADD(DAY, 6, R.FECHA)
FROM 
    Itinerario I
INNER JOIN 
    Reservacion R ON I.COD_RESERVA = R.COD_RESERVACION;
-----------------------------------------------------------
INSERT INTO RESERVACION (COD_RESERVACION, CANT_PERSONA, PRECIO, FECHA, COD_CLIENTE, COD_GUIA, COD_PAGO)
VALUES (11, 20, 6758.39, '2024-01-01', 63, 6, 4);

----INSERTAMOS DESTINO
INSERT INTO DESTINO (COD_DESTINO, NOMBRE, DESCRIPCION, HOSPEDAJE, RESTAURANTE, COD_CAT) VALUES
(26, 'Cerro de la Cruz', 'Mirador natural con vista panorámica de Quetzaltenango', 'Hotel Mirador', 'El Cerro Grill', 3),
(27, 'Cenote Azul', 'Cenote cristalino ideal para buceo', 'Cabañas Cenote', 'Restaurante El Agua', 1),
(28, 'Patzicia', 'Famoso por su cerámica artesanal', 'Hostal Patzicia', 'La Fogata', 2),
(29, 'Monte Alto', 'Sitio arqueológico con cabezas monumentales', 'No aplica', 'No aplica', 2),
(30, 'Champerico', 'Playa tropical cerca de Retalhuleu', 'Hotel Champerico', 'Mar y Sol', 4),
(31, 'Santiago Atitlán', 'Pueblo indígena en las orillas del lago', 'Hotel Santiago', 'La Cumbre', 3),
(32, 'Cahabón', 'Municipio cercano a Lanquín y Río Cahabón', 'Lodging Cahabón', 'Café del Río', 1),
(33, 'Jutiapa', 'Zona volcánica con paisajes únicos', 'Hotel Jutiapa', 'Plaza Central', 3),
(34, 'Tecpán', 'Ciudad colonial cerca de Chichicastenango', 'Hostal Tecpán', 'Comedor Antiguo', 2),
(35, 'Raxrujá', 'Área selvática con cascadas y ríos', 'Campamento Selva', 'Raxrujá Lodge', 1),
(36, 'San Andrés Semetabaj', 'Pueblo lacustre en el departamento de Baja Verapaz', 'Hotel La Laguna', 'Sabores de Tierra', 3),
(37, 'Santa Cruz del Quiché', 'Base para explorar sitios mayas', 'Hotel Santa Cruz', 'El Mercado', 2),
(38, 'El Estor', 'Puerto sobre el lago Izabal', 'Hotel Lago Izabal', 'Restaurante El Estor', 3),
(39, 'Sayaxché', 'Entrada a sitios mayas como Uxmal', 'Hotel Sayaxché', 'Selva Maya Resto', 2),
(40, 'Petén Itzá', 'Isla en el lago Petén Itzá', 'Cabañas Petén', 'La Isla', 4),
(41, 'Cobá', 'Sitio arqueológico rodeado de selva', 'No aplica', 'No aplica', 2),
(42, 'Rabinal', 'Región cultural del baile de los moros', 'Hotel Rabinal', 'Café Tradicional', 2),
(43, 'Santa Elena', 'Pueblo cercano a Flores y Tikal', 'Hotel Santa Elena', 'La Palapa', 3),
(44, 'Uspantán', 'Conocida por sus tradiciones espirituales', 'Hotel Uspantán', 'La Sierra', 2),
(45, 'San Miguel Chicaj', 'Acceso a parques naturales en Alta Verapaz', 'Hostal San Miguel', 'La Cascada', 1),
(46, 'Poptún', 'Zona intermedia entre la selva y Tikal', 'Hotel Poptún', 'Sabores Selva', 3),
(47, 'Santa María de Jesús', 'Vista al Volcán de Agua desde Antigua', 'Hotel Santa María', 'Terraza del Volcán', 5),
(48, 'San Lucas Tolimán', 'Pueblo junto al lago Atitlán', 'Hotel San Lucas', 'La Bahía', 3),
(49, 'Cubulco', 'Herencia cultural maya-k’iche’', 'Hotel Cubulco', 'El Encuentro', 2),
(50, 'Purulá', 'Pueblo cercano a Cobán con clima fresco', 'Hotel Purulá', 'La Montaña', 3),
(51, 'Cataratas de La Pasadita', 'Cascadas escondidas en Huehuetenango', 'No aplica', 'No aplica', 1),
(52, 'Cantel', 'Zona agrícola y tranquila en Quetzaltenango', 'Hotel Cantel', 'Casa del Campo', 3),
(53, 'Sumpango', 'Famoso por su Festival de Barriletes Gigantes', 'Hotel Sumpango', 'Barrilete Grill', 2),
(54, 'Mixco Viejo', 'Ruinas arqueológicas en forma de fortaleza', 'No aplica', 'No aplica', 2),
(55, 'San José El Ídolo', 'Famoso por su feria patronal y cultura local', 'Hostal El Ídolo', 'La Feria', 2),
(56, 'Río Ixcán', 'Zona de ríos y selva virgen', 'Campamento Ixcán', 'El Refugio', 1),
(57, 'Santa Catarina Mita', 'Pueblo conocido por su café', 'Hotel Mita', 'Café Real', 3),
(58, 'Esquipulas', 'Importante centro religioso con basílica famosa', 'Hotel Esquipulas', 'La Fe', 2),
(59, 'Ocosingo', 'Pueblo fronterizo con influencias mayas', 'Hotel Frontera', 'La Venta', 3),
(60, 'Carmelita', 'Aldea cercana a El Petén y Tikal', 'Hotel Carmelita', 'Selva Norte', 2),
(61, 'La Unión', 'Playa tranquila en el Pacífico guatemalteco', 'Hotel Playa Dorada', 'El Mar', 4),
(62, 'Cerro Quiac', 'Mirador natural en Totonicapán', 'No aplica', 'No aplica', 3),
(63, 'San Mateo Ixtatán', 'Pueblo indígena en Huehuetenango', 'Hotel San Mateo', 'Café del Norte', 2),
(64, 'Salamá', 'Capital de Baja Verapaz', 'Hotel Salamá', 'El Valle', 3),
(65, 'San Sebastián Coatán', 'Pueblo en la región occidental', 'Hotel Coatán', 'La Sierra', 2),
(66, 'El Asintal', 'Área arqueológica en Petén', 'No aplica', 'No aplica', 2),
(67, 'Cajolá', 'Reconocida por tejidos y artesanías', 'Hostal Cajolá', 'Tejidos del Alba', 2),
(68, 'San Antonio Huista', 'Pueblo con clima cálido y cultivo de café', 'Hotel Huista', 'El Cafetal', 3),
(69, 'Santa Ana Huista', 'Aldea cercana a Huehuetenango', 'Hotel Santa Ana', 'La Casona', 2),
(70, 'Río Dulce - Islas de Amatique', 'Archipiélago natural en el Caribe', 'Hotel Amatique', 'Islas del Sol', 4),
(71, 'Yaxhá', 'Sitio arqueológico en plena selva', 'No aplica', 'No aplica', 2),
(72, 'Cerro de Oro', 'Reserva natural en Alta Verapaz', 'Campamento Verde', 'Refugio Selva', 1),
(73, 'La Blanca', 'Área arqueológica en San Marcos', 'No aplica', 'No aplica', 2),
(74, 'Parque Nacional Laguna del Tigre', 'Área protegida en el norte de Petén', 'Campamento Tigre', 'La Selva', 1),
(75, 'Cerro San Gil', 'Reserva biológica en Izabal', 'Campamento Selva Izabal', 'El Sendero', 3),
(76, 'Ixil', 'Triángulo cultural en Huehuetenango', 'Hotel Ixil', 'Cultura Maya', 2),
(77, 'Santa Lucía Milpas Altas', 'Tradición culinaria en Sacatepéquez', 'Hotel Milpas', 'La Cocina Típica', 3),
(78, 'San José Ojetenam', 'Pueblo con festividades únicas', 'Hotel Ojetenam', 'El Hogar', 2),
(79, 'San Juan Ermita', 'Fiesta patronal famosa en Jalapa', 'Hotel Ermita', 'La Plaza', 3),
(80, 'La Democracia', 'Playa de arena negra cerca de Santa Lucía Cotzumalguapa', 'Hotel Arena Negra', 'El Sur', 4),
(81, 'San Jorge', 'Municipio en Zacapa con historia minera', 'Hotel San Jorge', 'Minero Grill', 3),
(82, 'San Rafael Pie de la Cuesta', 'Pueblo costeño en Escuintla', 'Hotel Pie de la Cuesta', 'El Puerto', 4),
(83, 'Cerro Conejo', 'Área recreativa en Suchitepéquez', 'Campamento Conejo', 'La Cueva', 1),
(84, 'San Pablo Jocopilas', 'Isla en el lago Coatepeque', 'Hotel Jocopilas', 'La Isla Linda', 3),
(85, 'San Francisco El Alto', 'Centro textil en Totonicapán', 'Hotel El Alto', 'Tejidos del Alma', 2),
(86, 'San Miguel Ixtahuacán', 'Pueblo productor de maíz y frijoles', 'Hostal Ixtahuacán', 'El Campo', 3),
(87, 'San Pedro Sacatepéquez', 'Frontera con México y rutas históricas', 'Hotel Frontera', 'La Troje', 2),
(88, 'San Antonio de Pichillá', 'Aldea cercana a Chimaltenango', 'Hotel Pichillá', 'La Colina', 3),
(89, 'San Gaspar Ixchil', 'Zona rural con paisaje serrano', 'Hostal Ixchil', 'La Sierra', 2),
(90, 'San Andrés', 'Isla paradisíaca en el Caribe', 'Hotel San Andrés', 'El Caribeño', 4),
(91, 'El Porvenir', 'Aldea con cascadas y bosques', 'Campamento El Porvenir', 'La Cascada', 1),
(92, 'San José Calderas', 'Pueblo en el altiplano sur', 'Hotel Calderas', 'Altos del Sur', 3),
(93, 'San Bartolo Tutultepec', 'Aldea con tradiciones únicas', 'Hotel Tutultepec', 'El Corazón', 2),
(94, 'San Vicente Pacaya', 'Cerca del Volcán Pacaya', 'Campamento Pacaya', 'La Lava', 1),
(95, 'San Mateo', 'Pueblo tranquilo en Suchitepéquez', 'Hotel San Mateo', 'El Rincón', 3),
(96, 'San José de la Montaña', 'Zona montañosa en Sololá', 'Hotel Montaña', 'La Cima', 3),
(97, 'San Simón', 'Pueblo cercano a Retalhuleu', 'Hotel San Simón', 'La Tradición', 2),
(98, 'San Luis', 'Aldea en el departamento de El Progreso', 'Hostal San Luis', 'El Horizonte', 3),
(99, 'San Ramón', 'Valle verde en Baja Verapaz', 'Hotel Valle Verde', 'La Sabana', 5),
(100, 'San Nicolás Tolentino', 'Aldea con iglesia colonial antigua', 'Hotel San Nicolás', 'La Historia', 2);

UPDATE ITINERARIO
SET COD_DESTINO = ABS(CHECKSUM(NEWID()) % 100) + 1;
-- Asumimos que la tabla se llama ASIGNA
INSERT INTO ASIGNA (COD_TRANS, COD_ITINE)
SELECT 
    ((ROW_NUMBER() OVER (ORDER BY SEQ) - 1) % 5) + 1 AS COD_TRANS, 
    SEQ AS COD_ITINE
FROM (
    -- Generamos una secuencia del 1 al 240
    SELECT TOP 240 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS SEQ
    FROM SYS.ALL_OBJECTS
) AS SEQUENCE
WHERE SEQ > 10; -- Ya tiene 10 registros, empezamos desde el 11

--RESERVACION
SELECT 
            R.COD_RESERVACION,
            R.CANT_PERSONA,
            R.PRECIO,
            R.FECHA,
            C.NOMBRE AS Cliente,
            G.NOMBRE AS Guia,
            P.TIPO_PAGO AS Tipo_Pago,
            
            -- Datos del itinerario
            I.COD_ITINERARIO,
            I.FECHA_SALIDA,
            I.FECHA_ENTRADA,
            D.NOMBRE AS Destino,
            
            -- Campos calculados para análisis
            DATEDIFF(day, I.FECHA_SALIDA, I.FECHA_ENTRADA) + 1 AS Duracion_Dias,
            YEAR(R.FECHA) AS [Año],
            MONTH(R.FECHA) AS Mes,
            DATENAME(month, R.FECHA) AS Nombre_Mes,
            DATEPART(quarter, R.FECHA) AS Trimestre,
            DATENAME(weekday, R.FECHA) AS Dia_Semana,
            
            -- Métricas de negocio
            R.PRECIO / R.CANT_PERSONA AS Precio_Por_Persona,
            CASE 
                WHEN R.CANT_PERSONA >= 8 THEN 'Grupo Grande'
                WHEN R.CANT_PERSONA >= 4 THEN 'Grupo Mediano'
                ELSE 'Grupo Pequeño'
            END AS Tipo_Grupo
        
        FROM RESERVACION R
        JOIN CLIENTE C ON C.COD_CLIENTE = R.COD_CLIENTE
        JOIN GUIA G ON G.COD_GUIA = R.COD_GUIA
        JOIN PAGO P ON P.COD_PAGO = R.COD_PAGO
        LEFT JOIN ITINERARIO I ON I.COD_RESERVA = R.COD_RESERVACION
        LEFT JOIN DESTINO D ON D.COD_DESTINO = I.COD_DESTINO
        ORDER BY R.FECHA DESC

--INGRESOS MENSUALES
SELECT 
            YEAR(R.FECHA) as [Año],
            MONTH(R.FECHA) as Mes,
            DATENAME(month, R.FECHA) as Nombre_Mes,
            COUNT(R.COD_RESERVACION) as Cantidad_Reservaciones,
            SUM(R.PRECIO) as Ingresos_Totales,
            SUM(R.CANT_PERSONA) as Total_Personas,
            AVG(R.PRECIO) as Precio_Promedio
        FROM RESERVACION R
        GROUP BY YEAR(R.FECHA), MONTH(R.FECHA), DATENAME(month, R.FECHA)
        ORDER BY [Año], Mes

--DESTIONOS POPULARES
SELECT 
            D.NOMBRE as Destino,
            COUNT(I.COD_ITINERARIO) as Cantidad_Tours,
            SUM(R.PRECIO) as Ingresos_Generados,
            SUM(R.CANT_PERSONA) as Total_Personas,
            AVG(R.PRECIO) as Precio_Promedio,
			YEAR(I.FECHA_SALIDA) as Año
        FROM DESTINO D
        LEFT JOIN ITINERARIO I ON D.COD_DESTINO = I.COD_DESTINO
        LEFT JOIN RESERVACION R ON I.COD_RESERVA = R.COD_RESERVACION
        GROUP BY D.NOMBRE, I.FECHA_SALIDA
        ORDER BY Cantidad_Tours DESC

--PERFORMANCE GUIAS
SELECT 
            G.NOMBRE as Guia,
            COUNT(R.COD_RESERVACION) as Total_Tours,
            SUM(R.PRECIO) as Ingresos_Generados,
            SUM(R.CANT_PERSONA) as Total_Personas_Guiadas,
            AVG(R.PRECIO) as Precio_Promedio_Tour,
            AVG(CAST(R.CANT_PERSONA AS FLOAT)) as Promedio_Personas_Por_Tour,
			YEAR(R.FECHA) as Año
        FROM GUIA G
        LEFT JOIN RESERVACION R ON G.COD_GUIA = R.COD_GUIA
        GROUP BY G.NOMBRE, R.FECHA
        ORDER BY Total_Tours DESC

--METRICAS KPI
SELECT 
            COUNT(R.COD_RESERVACION) as Total_Reservaciones,
--			AVG(R.COD_RESERVACION) as Promedio_Reservaciones,
            SUM(R.PRECIO) as Ingresos_Totales,
            SUM(R.CANT_PERSONA) as Total_Personas,
            AVG(R.PRECIO) as Precio_Promedio,
            AVG(CAST(R.CANT_PERSONA AS FLOAT)) as Promedio_Personas_Por_Tour,
            -- Métricas del mes actual
            COUNT(CASE WHEN MONTH(R.FECHA) = MONTH(GETDATE()) 
                       AND YEAR(R.FECHA) = YEAR(GETDATE()) THEN 1 END) as Reservaciones_Mes_Actual,
            SUM(CASE WHEN MONTH(R.FECHA) = MONTH(GETDATE()) 
                     AND YEAR(R.FECHA) = YEAR(GETDATE()) THEN R.PRECIO ELSE 0 END) as Ingresos_Mes_Actual,
            -- Métricas del año actual
            COUNT(CASE WHEN YEAR(R.FECHA) = YEAR(GETDATE()) THEN 1 END) as Reservaciones_Año_Actual,
            SUM(CASE WHEN YEAR(R.FECHA) = YEAR(GETDATE()) THEN R.PRECIO ELSE 0 END) as Ingresos_Año_Actual
        FROM RESERVACION R

--METRICAS KPI 2
SELECT 
    -- Métricas totales (históricas)
    COUNT(R.COD_RESERVACION) as Total_Reservaciones,
    SUM(R.PRECIO) as Ingresos_Totales,
    SUM(R.CANT_PERSONA) as Total_Personas,
    AVG(R.PRECIO) as Precio_Promedio,
    AVG(CAST(R.CANT_PERSONA AS FLOAT)) as Promedio_Personas_Por_Tour,
    -- Métricas del mes actual
    COUNT(CASE WHEN MONTH(R.FECHA) = MONTH(GETDATE()) 
               AND YEAR(R.FECHA) = YEAR(GETDATE()) THEN 1 END) as Reservaciones_Mes_Actual,
    SUM(CASE WHEN MONTH(R.FECHA) = MONTH(GETDATE()) 
             AND YEAR(R.FECHA) = YEAR(GETDATE()) THEN R.PRECIO ELSE 0 END) as Ingresos_Mes_Actual,
    -- Métricas del año actual
    COUNT(CASE WHEN YEAR(R.FECHA) = YEAR(GETDATE()) THEN 1 END) as Reservaciones_Año_Actual,
    SUM(CASE WHEN YEAR(R.FECHA) = YEAR(GETDATE()) THEN R.PRECIO ELSE 0 END) as Ingresos_Año_Actual,
    -- NUEVOS: Promedios mensuales (para usar como metas/benchmarks)
    -- Promedio de reservaciones por mes
    CASE 
        WHEN COUNT(DISTINCT CONCAT(YEAR(R.FECHA), '-', MONTH(R.FECHA))) = 0 THEN 0
        ELSE CAST(COUNT(R.COD_RESERVACION) AS FLOAT) / COUNT(DISTINCT CONCAT(YEAR(R.FECHA), '-', MONTH(R.FECHA)))
    END as Promedio_Reservaciones_Por_Mes,
    -- Promedio de ingresos por mes
    CASE 
        WHEN COUNT(DISTINCT CONCAT(YEAR(R.FECHA), '-', MONTH(R.FECHA))) = 0 THEN 0
        ELSE SUM(R.PRECIO) / COUNT(DISTINCT CONCAT(YEAR(R.FECHA), '-', MONTH(R.FECHA)))
    END as Promedio_Ingresos_Por_Mes,
    -- Promedio de personas por mes
    CASE 
        WHEN COUNT(DISTINCT CONCAT(YEAR(R.FECHA), '-', MONTH(R.FECHA))) = 0 THEN 0
        ELSE CAST(SUM(R.CANT_PERSONA) AS FLOAT) / COUNT(DISTINCT CONCAT(YEAR(R.FECHA), '-', MONTH(R.FECHA)))
    END as Promedio_Personas_Por_Mes,
    -- Promedio mensual solo del año actual (más relevante para metas)
    CASE 
        WHEN COUNT(DISTINCT CASE WHEN YEAR(R.FECHA) = YEAR(GETDATE()) 
                                 THEN CONCAT(YEAR(R.FECHA), '-', MONTH(R.FECHA)) END) = 0 THEN 0
        ELSE CAST(COUNT(CASE WHEN YEAR(R.FECHA) = YEAR(GETDATE()) THEN 1 END) AS FLOAT) / 
             COUNT(DISTINCT CASE WHEN YEAR(R.FECHA) = YEAR(GETDATE()) 
                                THEN CONCAT(YEAR(R.FECHA), '-', MONTH(R.FECHA)) END)
    END as Promedio_Reservaciones_Por_Mes_Año_Actual,
    CASE 
        WHEN COUNT(DISTINCT CASE WHEN YEAR(R.FECHA) = YEAR(GETDATE()) 
                                 THEN CONCAT(YEAR(R.FECHA), '-', MONTH(R.FECHA)) END) = 0 THEN 0
        ELSE SUM(CASE WHEN YEAR(R.FECHA) = YEAR(GETDATE()) THEN R.PRECIO ELSE 0 END) / 
             COUNT(DISTINCT CASE WHEN YEAR(R.FECHA) = YEAR(GETDATE()) 
                                THEN CONCAT(YEAR(R.FECHA), '-', MONTH(R.FECHA)) END)
    END as Promedio_Ingresos_Por_Mes_Año_Actual,
    -- Información adicional útil
    COUNT(DISTINCT CONCAT(YEAR(R.FECHA), '-', MONTH(R.FECHA))) as Total_Meses_Con_Datos,
    COUNT(DISTINCT CASE WHEN YEAR(R.FECHA) = YEAR(GETDATE()) 
                       THEN CONCAT(YEAR(R.FECHA), '-', MONTH(R.FECHA)) END) as Meses_Con_Datos_Año_Actual
FROM RESERVACION R

--METRICAS KPI 3
SELECT 
    -- ========================================
    -- PARTE 1: TOTALES HISTÓRICOS
    -- ========================================
    COUNT(R.COD_RESERVACION) as Total_Reservaciones,
    SUM(R.PRECIO) as Total_Ingresos,
    SUM(R.CANT_PERSONA) as Total_Personas,
    -- ========================================
    -- PARTE 2: PROMEDIOS MENSUALES
    -- ========================================
    -- Cálculo de meses totales (desde la fecha más antigua hasta la más nueva)
    DATEDIFF(MONTH, MIN(R.FECHA), MAX(R.FECHA)) + 1 as Total_Meses_Periodo,
    -- Promedios mensuales basados en el período completo
    CASE 
        WHEN DATEDIFF(MONTH, MIN(R.FECHA), MAX(R.FECHA)) + 1 = 0 THEN 0
        ELSE CAST(COUNT(R.COD_RESERVACION) AS FLOAT) / (DATEDIFF(MONTH, MIN(R.FECHA), MAX(R.FECHA)) + 1)
    END as Promedio_Reservaciones_Por_Mes,
    CASE 
        WHEN DATEDIFF(MONTH, MIN(R.FECHA), MAX(R.FECHA)) + 1 = 0 THEN 0
        ELSE SUM(R.PRECIO) / (DATEDIFF(MONTH, MIN(R.FECHA), MAX(R.FECHA)) + 1)
    END as Promedio_Ingresos_Por_Mes,
    CASE 
        WHEN DATEDIFF(MONTH, MIN(R.FECHA), MAX(R.FECHA)) + 1 = 0 THEN 0
        ELSE CAST(SUM(R.CANT_PERSONA) AS FLOAT) / (DATEDIFF(MONTH, MIN(R.FECHA), MAX(R.FECHA)) + 1)
    END as Promedio_Personas_Por_Mes,
    -- ========================================
    -- PARTE 3: TOTALES DEL MES ACTUAL
    -- ========================================
    COUNT(CASE WHEN MONTH(R.FECHA) = MONTH(GETDATE()) 
               AND YEAR(R.FECHA) = YEAR(GETDATE()) THEN 1 END) as Reservaciones_Mes_Actual,
    SUM(CASE WHEN MONTH(R.FECHA) = MONTH(GETDATE()) 
             AND YEAR(R.FECHA) = YEAR(GETDATE()) THEN R.PRECIO ELSE 0 END) as Ingresos_Mes_Actual,
    SUM(CASE WHEN MONTH(R.FECHA) = MONTH(GETDATE()) 
             AND YEAR(R.FECHA) = YEAR(GETDATE()) THEN R.CANT_PERSONA ELSE 0 END) as Personas_Mes_Actual,
    -- Información adicional útil
    MIN(R.FECHA) as Fecha_Mas_Antigua,
    MAX(R.FECHA) as Fecha_Mas_Nueva
 
FROM RESERVACION R

--ANALISIS DE PAGOS (NO SE UTILIZÓ)
SELECT 
            P.TIPO_PAGO,
            COUNT(R.COD_RESERVACION) as Cantidad_Reservaciones,
            SUM(R.PRECIO) as Ingresos_Totales,
            AVG(R.PRECIO) as Precio_Promedio,
            SUM(R.CANT_PERSONA) as Total_Personas,
            (COUNT(R.COD_RESERVACION) * 100.0 / 
                (SELECT COUNT(*) FROM RESERVACION)) as Porcentaje_Participacion
        FROM PAGO P
        LEFT JOIN RESERVACION R ON P.COD_PAGO = R.COD_PAGO
        GROUP BY P.TIPO_PAGO, P.COD_PAGO
        ORDER BY Cantidad_Reservaciones DESC

--ANALISIS TEMPORAL (NO SIRVE)
SELECT 
            DATENAME(weekday, R.FECHA) as Dia_Semana,
            DATEPART(weekday, R.FECHA) as Num_Dia,
            COUNT(R.COD_RESERVACION) as Cantidad_Reservaciones,
            SUM(R.PRECIO) as Ingresos_Totales,
            AVG(R.PRECIO) as Precio_Promedio
        FROM RESERVACION R
        GROUP BY DATENAME(weekday, R.FECHA), DATEPART(weekday, R.FECHA)
        ORDER BY Num_Dia

--ANALISIS DURACION (NO SE UTILIZÓ)
SELECT 
            DATEDIFF(day, I.FECHA_SALIDA, I.FECHA_ENTRADA) + 1 as Duracion_Dias,
            COUNT(I.COD_ITINERARIO) as Cantidad_Tours,
            SUM(R.PRECIO) as Ingresos_Totales,
            AVG(R.PRECIO) as Precio_Promedio,
            D.NOMBRE as Destino
        FROM ITINERARIO I
        JOIN RESERVACION R ON I.COD_RESERVA = R.COD_RESERVACION
        JOIN DESTINO D ON I.COD_DESTINO = D.COD_DESTINO
        GROUP BY DATEDIFF(day, I.FECHA_SALIDA, I.FECHA_ENTRADA) + 1, D.NOMBRE
        ORDER BY Duracion_Dias, Cantidad_Tours DESC

--VER ESTE CODIGO PARA ELIMINAR EL 2026
SELECT 
            D.NOMBRE as Destino,
			YEAR(I.FECHA_SALIDA) as Año
        FROM DESTINO D
        LEFT JOIN ITINERARIO I ON D.COD_DESTINO = I.COD_DESTINO
        LEFT JOIN RESERVACION R ON I.COD_RESERVA = R.COD_RESERVACION
		WHERE YEAR(I.FECHA_SALIDA) = 2026
        GROUP BY D.NOMBRE, I.FECHA_SALIDA

SELECT*FROM ACTIVIDAD
SELECT*FROM ASIGNA
SELECT*FROM CATEGORIA
SELECT*FROM CELULAR
SELECT*FROM CLIENTE
SELECT*FROM GUIA
SELECT*FROM HABLA
SELECT*FROM IDIOMA
SELECT*FROM ITINERARIO
SELECT*FROM PAGO
SELECT*FROM REALIZA
SELECT*FROM RESERVACION
SELECT*FROM TIPO_ACTIVIDAD
SELECT*FROM TIPO_IDENTIFICACION
SELECT*FROM TIPO_TRANSPORTE
SELECT*FROM TRANSPORTE
SELECT*FROM VIAJE
SELECT*FROM PAIS
SELECT*FROM DESTINO

/*OBJETIVO DE ESTE PROYECTO 25/08

-TOMA REQUERIMIENTOS
-DISEÑO BASE DE DATOS RELACIONAL
-DATOS
-TABLEROS CON PB/SSRS
-DISEÑO DE BASE DE DATOS NO RELACIONAL
(1. CREAR UNA TABLA 0FN, HACER JOINS CON TODAS LAS TABLAS Y METERLO A MONGO, TIPO RESUMEN
 2. USAR LA MISMA BD RELACIONAL EN MONGO
 3. CREAR UN NUEVO MODULO (REDES SOCIALES/MARKETING) SI SE INCLUYE ESTA HAY QUE AGREGARLO A LA TOMA DE REQUERIMIENTO)
-MANUAL DE PROGRAMACIÓN
-MARCO TEORICO (JULIO)
-CRUD DE PYTHON A SQL (MARCO)
-CRUD DE R A MONGODB (OSCAR)*/

SELECT 
     I.COD_RESERVA as ID_RESERVA,
	 G.NOMBRE AS NOMBRE,
       D.NOMBRE as Destino,
            COUNT(I.COD_ITINERARIO) as Cantidad_Tours,
            SUM(R.PRECIO) as Ingresos_Generados,
            SUM(R.CANT_PERSONA) as Total_Personas,
            AVG(R.PRECIO) as Precio_Promedio,
			YEAR(I.FECHA_SALIDA) as Año
        FROM DESTINO D
        INNER JOIN ITINERARIO I ON D.COD_DESTINO = I.COD_DESTINO
        INNER JOIN RESERVACION R ON I.COD_RESERVA = R.COD_RESERVACION
		INNER JOIN GUIA G ON R.COD_GUIA = G.COD_GUIA
        GROUP BY D.NOMBRE, I.FECHA_SALIDA, G.NOMBRE, I.COD_RESERVA
        ORDER BY Cantidad_Tours DESC


SELECT TT.TIPO_TRANS, D.NOMBRE
FROM RESERVACION R
INNER JOIN ITINERARIO I ON R.COD_RESERVACION = I.COD_RESERVA
INNER JOIN DESTINO D ON I.COD_DESTINO = D.COD_DESTINO
INNER JOIN ASIGNA A ON I.COD_ITINERARIO = A.COD_ITINE
INNER JOIN TRANSPORTE T ON A.COD_TRANS = T.COD_TRANS
INNER JOIN TIPO_TRANSPORTE TT ON T.COD_TIPO = TT.COD_TIPO_TRANS

SELECT I.FECHA_SALIDA AS FECHA_SALIDA, I.FECHA_ENTRADA AS FECHA_ENTRADA, C.NOMBRE AS NOMBRE_CLIENTE, P.TIPO_PAGO AS TIPO_PAGO, D.NOMBRE AS NOMBRE_DESTINO, R.CANT_PERSONA AS CANT_PERSONAS, A.NOMBRE AS NOMBRE_ACTIVIDAD, TA.DESCRIPCION AS TIPO_ACTIVIDAD, G.NOMBRE AS NOMBRE_GUIA, TT.TIPO_TRANS AS TIPO_TRANSPORTE, TT.CAPACIDAD AS CAPACIDAD_TRANSPORTE
FROM RESERVACION R
INNER JOIN ITINERARIO I ON R.COD_RESERVACION = I.COD_RESERVA
INNER JOIN CLIENTE C ON R.COD_CLIENTE = C.COD_CLIENTE
INNER JOIN PAGO P ON R.COD_PAGO = P.COD_PAGO
INNER JOIN DESTINO D ON I.COD_DESTINO = D.COD_DESTINO
INNER JOIN REALIZA RA ON D.COD_DESTINO = RA.COD_DESTINO
INNER JOIN ACTIVIDAD A ON RA.COD_ACTIV = A.COD_ACTIV
INNER JOIN TIPO_ACTIVIDAD TA ON A.COD_TIPO_ACTIV = TA.COD_TIPO_ACTIV
INNER JOIN GUIA G ON R.COD_GUIA = G.COD_GUIA
INNER JOIN ASIGNA AG ON I.COD_ITINERARIO = AG.COD_ITINE
INNER JOIN TRANSPORTE T ON AG.COD_TRANS = T.COD_TRANS
INNER JOIN TIPO_TRANSPORTE TT ON T.COD_TIPO = TT.COD_TIPO_TRANS
WHERE R.FECHA > CAST(GETDATE() AS DATE)


--VER LA CANTIDAD DE PERSONAS QUE CABEN EN LOS VEHICULOS
SELECT R.CANT_PERSONA AS PERSONAS, TT.CAPACIDAD AS CAPACIDAD_TRANS, TT.TIPO_TRANS
FROM RESERVACION R
INNER JOIN ITINERARIO I ON R.COD_RESERVACION = I.COD_RESERVA
INNER JOIN CLIENTE C ON R.COD_CLIENTE = C.COD_CLIENTE
INNER JOIN PAGO P ON R.COD_PAGO = P.COD_PAGO
INNER JOIN DESTINO D ON I.COD_DESTINO = D.COD_DESTINO
INNER JOIN REALIZA RA ON D.COD_DESTINO = RA.COD_DESTINO
INNER JOIN ACTIVIDAD A ON RA.COD_ACTIV = A.COD_ACTIV
INNER JOIN TIPO_ACTIVIDAD TA ON A.COD_TIPO_ACTIV = TA.COD_TIPO_ACTIV
INNER JOIN GUIA G ON R.COD_GUIA = G.COD_GUIA
INNER JOIN ASIGNA AG ON I.COD_ITINERARIO = AG.COD_ITINE
INNER JOIN TRANSPORTE T ON AG.COD_TRANS = T.COD_TRANS
INNER JOIN TIPO_TRANSPORTE TT ON T.COD_TIPO = TT.COD_TIPO_TRANS

