-- ==========================================================
-- Módulo 4: Extrayendo métricas clave con SQL
-- ==========================================================

USE Ventas_Tech_DB;


-- ==========================================================
-- Consulta 1 — Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes.
-- ==========================================================
SELECT 
    MONTH(fecha_venta) AS mes,
    COUNT(id_venta) AS total_pedidos,
    SUM(cantidad * precio_unitario) AS total_facturado,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- ==========================================================
-- Consulta 2 — Ranking de productos
-- Top 5 de id_producto por total facturado, unidades vendidas y total generado.
-- ==========================================================
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS total_unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;


-- ==========================================================
-- Consulta 3 — Clientes recurrentes
-- Clientes que hayan realizado más de un pedido, con su cantidad de pedidos y total gastado.
-- ==========================================================
SELECT 
    id_cliente,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(id_venta) > 1
ORDER BY total_gastado DESC;


-- ==========================================================
-- Consulta 4 — Meses por encima/por debajo del promedio
-- Total facturado por mes etiquetado con CASE WHEN comparado con el promedio general.
-- ==========================================================
WITH VentasPorMes AS (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_mes
    FROM ventas
    GROUP BY MONTH(fecha_venta)
),
PromedioGeneral AS (
    SELECT AVG(total_mes) AS promedio_mensual FROM VentasPorMes
)
SELECT 
    v.mes,
    v.total_mes AS total_facturado,
    CASE 
        WHEN v.total_mes > p.promedio_mensual THEN 'Por encima'
        ELSE 'Por debajo'
    END AS rendimiento_mes
FROM VentasPorMes v
CROSS JOIN PromedioGeneral p;


-- ==========================================================
-- Hallazgos concretos del negocio
-- ==========================================================
-- 1. El producto con "id_producto = 1" lleva la mayor facturación de las transacciones registradas
-- 2. Los clientes con id_cliente 1 y 5 destacan como los más frecuentes y de mayor gasto
-- 3. La facturación mensual muestra variaciones marcadas, permitiendo identificar claramente qué periodos superan el promedio general de ventas
