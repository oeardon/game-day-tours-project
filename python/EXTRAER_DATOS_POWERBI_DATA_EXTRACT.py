# Script para Power BI Desktop - Game Day Tours
import pyodbc
import pandas as pd

# === CONFIGURACIÓN DE CONEXIÓN ===
SERVER = 'SERVIDOR_SQL_SERVER'
DATABASE = 'GAME_DAY_TOURS'

def connect():
    conn_str = (
        f'DRIVER={{ODBC Driver 17 for SQL Server}};'
        f'SERVER={SERVER};'
        f'DATABASE={DATABASE};'
        f'Trusted_Connection=yes;'
    )
    try:
        return pyodbc.connect(conn_str)
    except Exception as e:
        print("Error al conectar:", e)
        return None

# === DATOS PRINCIPALES PARA POWER BI ===
conn = connect()

if conn:
    # Consulta principal que Power BI usará (solo columnas que existen)
    reservaciones = pd.read_sql("""
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
    """, conn)
    
    # Métricas mensuales
    ingresos_mensuales = pd.read_sql("""
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
    """, conn)
    
    # Análisis de destinos (sin columna UBICACION)
    destinos_populares = pd.read_sql("""
        SELECT 
            D.NOMBRE as Destino,
            COUNT(I.COD_ITINERARIO) as Cantidad_Tours,
            SUM(R.PRECIO) as Ingresos_Generados,
            SUM(R.CANT_PERSONA) as Total_Personas,
            AVG(R.PRECIO) as Precio_Promedio
        FROM DESTINO D
        LEFT JOIN ITINERARIO I ON D.COD_DESTINO = I.COD_DESTINO
        LEFT JOIN RESERVACION R ON I.COD_RESERVA = R.COD_RESERVACION
        GROUP BY D.NOMBRE
        ORDER BY Cantidad_Tours DESC
    """, conn)
    
    # Performance por guía (sin columna TELEFONO)
    performance_guias = pd.read_sql("""
        SELECT 
            G.NOMBRE as Guia,
            COUNT(R.COD_RESERVACION) as Total_Tours,
            SUM(R.PRECIO) as Ingresos_Generados,
            SUM(R.CANT_PERSONA) as Total_Personas_Guiadas,
            AVG(R.PRECIO) as Precio_Promedio_Tour,
            AVG(CAST(R.CANT_PERSONA AS FLOAT)) as Promedio_Personas_Por_Tour
        FROM GUIA G
        LEFT JOIN RESERVACION R ON G.COD_GUIA = R.COD_GUIA
        GROUP BY G.NOMBRE
        ORDER BY Total_Tours DESC
    """, conn)
    
    # Tabla resumen con métricas clave para KPIs
    metricas_kpi = pd.read_sql("""
        SELECT 
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
            SUM(CASE WHEN YEAR(R.FECHA) = YEAR(GETDATE()) THEN R.PRECIO ELSE 0 END) as Ingresos_Año_Actual
            
        FROM RESERVACION R
    """, conn)
    
    # Análisis por tipo de pago
    analisis_pagos = pd.read_sql("""
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
    """, conn)
    
    # Análisis temporal (por día de la semana)
    analisis_temporal = pd.read_sql("""
        SELECT 
            DATENAME(weekday, R.FECHA) as Dia_Semana,
            DATEPART(weekday, R.FECHA) as Num_Dia,
            COUNT(R.COD_RESERVACION) as Cantidad_Reservaciones,
            SUM(R.PRECIO) as Ingresos_Totales,
            AVG(R.PRECIO) as Precio_Promedio
        FROM RESERVACION R
        GROUP BY DATENAME(weekday, R.FECHA), DATEPART(weekday, R.FECHA)
        ORDER BY Num_Dia
    """, conn)
    
    # Análisis de duración de tours
    analisis_duracion = pd.read_sql("""
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
    """, conn)
    
    conn.close()
    
    print(f"✅ Datos cargados exitosamente:")
    print(f"   📋 Reservaciones: {len(reservaciones)} registros")
    print(f"   📊 Ingresos mensuales: {len(ingresos_mensuales)} registros") 
    print(f"   🗺️ Destinos populares: {len(destinos_populares)} registros")
    print(f"   👥 Performance guías: {len(performance_guias)} registros")
    print(f"   📈 Métricas KPI: {len(metricas_kpi)} registros")
    print(f"   💳 Análisis pagos: {len(analisis_pagos)} registros")
    print(f"   📅 Análisis temporal: {len(analisis_temporal)} registros")
    print(f"   ⏱️ Análisis duración: {len(analisis_duracion)} registros")

else:
    print("❌ Error al conectar con la base de datos")
    print("Verificar:")
    print(f"   - Servidor: {SERVER}")
    print(f"   - Base de datos: {DATABASE}")
    print("   - ODBC Driver 17 for SQL Server instalado")
    print("   - Permisos de acceso a la base de datos")
    
    # Crear DataFrames vacíos para evitar errores en Power BI
    reservaciones = pd.DataFrame()
    ingresos_mensuales = pd.DataFrame()
    destinos_populares = pd.DataFrame()
    performance_guias = pd.DataFrame()
    metricas_kpi = pd.DataFrame()
    analisis_pagos = pd.DataFrame()
    analisis_temporal = pd.DataFrame()
    analisis_duracion = pd.DataFrame()

# Power BI detectará automáticamente estas 8 tablas:
# 1. reservaciones - Datos principales completos
# 2. ingresos_mensuales - Para gráficos temporales
# 3. destinos_populares - Ranking de destinos
# 4. performance_guias - Análisis de guías  
# 5. metricas_kpi - KPIs principales del dashboard
# 6. analisis_pagos - Distribución por tipo de pago
# 7. analisis_temporal - Patrones por día de semana
# 8. analisis_duracion - Análisis de duración de tours