
-- ==========================================
-- RETAIL SALES ANALYSIS
-- 03 - ADVANCED SQL
-- ==========================================


-- 1. SUBQUERY
-- Mencari produk dengan penjualan di atas rata-rata penjualan produk

SELECT
    "Product Name",
    SUM("Sales") AS total_sales
FROM "sample"
GROUP BY "Product Name"
HAVING SUM("Sales") > (
    SELECT AVG(product_sales)
    FROM (
        SELECT SUM("Sales") AS product_sales
        FROM "sample"
        GROUP BY "Product Name"
    ) AS product_average
)
ORDER BY total_sales DESC;


-- 2. COMMON TABLE EXPRESSION (CTE)
-- Menghitung total sales dan profit setiap kategori

WITH category_summary AS (
    SELECT
        "Category",
        SUM("Sales") AS total_sales,
        SUM("Profit") AS total_profit
    FROM "sample"
    GROUP BY "Category"
)
SELECT
    "Category",
    total_sales,
    total_profit
FROM category_summary
ORDER BY total_sales DESC;


-- CTE: Menghitung performa penjualan setiap wilayah

WITH region_summary AS (
    SELECT
        "Region",
        SUM("Sales") AS total_sales,
        SUM("Profit") AS total_profit
    FROM "sample"
    GROUP BY "Region"
)
SELECT
    "Region",
    total_sales,
    total_profit,
    ROUND(
        (total_profit / NULLIF(total_sales, 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM region_summary
ORDER BY total_sales DESC;


-- 3. WINDOW FUNCTIONS
-- Ranking kategori berdasarkan total sales

SELECT
    "Category",
    SUM("Sales") AS total_sales,
    RANK() OVER (
        ORDER BY SUM("Sales") DESC
    ) AS sales_rank
FROM "sample"
GROUP BY "Category";


-- Ranking produk berdasarkan total sales

WITH product_summary AS (
    SELECT
        "Product Name",
        SUM("Sales") AS total_sales
    FROM "sample"
    GROUP BY "Product Name"
)
SELECT
    "Product Name",
    total_sales,
    RANK() OVER (
        ORDER BY total_sales DESC
    ) AS product_rank
FROM product_summary
LIMIT 10;


-- Menghitung running total penjualan bulanan

WITH monthly_sales AS (
    SELECT
        TO_CHAR(
            TO_DATE("Order Date", 'MM/DD/YYYY'),
            'YYYY-MM'
        ) AS order_month,
        SUM("Sales") AS total_sales
    FROM "sample"
    GROUP BY order_month
)
SELECT
    order_month,
    total_sales,
    SUM(total_sales) OVER (
        ORDER BY order_month
    ) AS running_total_sales
FROM monthly_sales
ORDER BY order_month;


-- 4. CASE WHEN
-- Mengelompokkan performa profit kategori

SELECT
    "Category",
    SUM("Sales") AS total_sales,
    SUM("Profit") AS total_profit,
    CASE
        WHEN SUM("Profit") > 0 THEN 'Profitable'
        WHEN SUM("Profit") < 0 THEN 'Loss'
        ELSE 'Break Even'
    END AS profit_status
FROM "sample"
GROUP BY "Category"
ORDER BY total_profit DESC;


-- Mengelompokkan nilai penjualan produk

WITH product_summary AS (
    SELECT
        "Product Name",
        SUM("Sales") AS total_sales
    FROM "sample"
    GROUP BY "Product Name"
)
SELECT
    "Product Name",
    total_sales,
    CASE
        WHEN total_sales >= 10000 THEN 'High Sales'
        WHEN total_sales >= 5000 THEN 'Medium Sales'
        ELSE 'Low Sales'
    END AS sales_category
FROM product_summary
ORDER BY total_sales DESC;
