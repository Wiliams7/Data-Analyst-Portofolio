
-- ==========================================
-- RETAIL SALES ANALYSIS
-- 02 - SQL ANALYSIS
-- ==========================================


-- 1. JOIN ANALYSIS
-- Menggabungkan tabel orders dan customers

SELECT
    o."Order ID",
    o."Customer ID",
    c."Customer Name",
    c."Segment",
    o."Sales",
    o."Profit"
FROM orders o
INNER JOIN customers c
    ON o."Customer ID" = c."Customer ID"
LIMIT 10;


-- 2. KEY PERFORMANCE INDICATORS (KPI)
-- Menghitung metrik utama bisnis

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT "Order ID") AS total_orders,
    COUNT(DISTINCT "Customer ID") AS total_customers,
    SUM("Sales") AS total_sales,
    SUM("Profit") AS total_profit,
    SUM("Quantity") AS total_quantity,
    ROUND(
        (SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100)::numeric,
        2
    ) AS profit_margin_percentage
FROM orders;


-- 3. SALES ANALYSIS
-- Analisis berdasarkan Category

SELECT
    "Category",
    SUM("Sales") AS total_sales,
    SUM("Profit") AS total_profit,
    SUM("Quantity") AS total_quantity,
    ROUND(
        (SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM "sample"
GROUP BY "Category"
ORDER BY total_sales DESC;


-- Analisis berdasarkan Region

SELECT
    "Region",
    SUM("Sales") AS total_sales,
    SUM("Profit") AS total_profit,
    SUM("Quantity") AS total_quantity,
    ROUND(
        (SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM "sample"
GROUP BY "Region"
ORDER BY total_sales DESC;


-- Analisis berdasarkan Segment

SELECT
    "Segment",
    SUM("Sales") AS total_sales,
    SUM("Profit") AS total_profit
FROM "sample"
GROUP BY "Segment"
ORDER BY total_sales DESC;


-- Analisis berdasarkan Ship Mode

SELECT
    "Ship Mode",
    SUM("Sales") AS total_sales,
    SUM("Profit") AS total_profit
FROM "sample"
GROUP BY "Ship Mode"
ORDER BY total_sales DESC;


-- 4. PRODUCT ANALYSIS
-- Analisis berdasarkan Sub-Category

SELECT
    "Sub-Category",
    SUM("Sales") AS total_sales,
    SUM("Profit") AS total_profit
FROM "sample"
GROUP BY "Sub-Category"
ORDER BY total_sales DESC;


-- Top 10 Products berdasarkan Sales

SELECT
    "Product Name",
    SUM("Sales") AS total_sales,
    SUM("Profit") AS total_profit
FROM "sample"
GROUP BY "Product Name"
ORDER BY total_sales DESC
LIMIT 10;


-- 10 Products dengan Profit terendah

SELECT
    "Product Name",
    SUM("Sales") AS total_sales,
    SUM("Profit") AS total_profit
FROM "sample"
GROUP BY "Product Name"
HAVING SUM("Profit") < 0
ORDER BY total_profit ASC
LIMIT 10;


-- 5. TIME ANALYSIS
-- Analisis penjualan berdasarkan tahun

SELECT
    EXTRACT(
        YEAR FROM TO_DATE("Order Date", 'MM/DD/YYYY')
    ) AS order_year,
    SUM("Sales") AS total_sales,
    SUM("Profit") AS total_profit
FROM "sample"
GROUP BY order_year
ORDER BY order_year;


-- Analisis tren penjualan bulanan

SELECT
    TO_CHAR(
        TO_DATE("Order Date", 'MM/DD/YYYY'),
        'YYYY-MM'
    ) AS order_month,
    SUM("Sales") AS total_sales,
    SUM("Profit") AS total_profit
FROM "sample"
GROUP BY order_month
ORDER BY order_month;
