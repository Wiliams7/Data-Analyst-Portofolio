
-- ==========================================
-- RETAIL SALES ANALYSIS
-- 01 - DATA PREPARATION
-- ==========================================


-- 1. DATA OVERVIEW
-- Melihat seluruh data
SELECT *
FROM "sample";

-- Menghitung jumlah baris data
SELECT COUNT(*) AS total_records
FROM "sample";

-- Melihat struktur data dan beberapa sampel
SELECT *
FROM "sample"
LIMIT 10;


-- 2. DATA VALIDATION
-- Memeriksa nilai NULL
SELECT
    COUNT(*) FILTER (WHERE "Order ID" IS NULL) AS null_order_id,
    COUNT(*) FILTER (WHERE "Customer ID" IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE "Order Date" IS NULL) AS null_order_date,
    COUNT(*) FILTER (WHERE "Sales" IS NULL) AS null_sales,
    COUNT(*) FILTER (WHERE "Profit" IS NULL) AS null_profit
FROM "sample";

-- Memeriksa duplikasi Row ID
SELECT
    "Row ID",
    COUNT(*) AS total
FROM "sample"
GROUP BY "Row ID"
HAVING COUNT(*) > 1;

-- Memeriksa rentang tanggal pesanan
SELECT
    MIN(TO_DATE("Order Date", 'MM/DD/YYYY')) AS earliest_order,
    MAX(TO_DATE("Order Date", 'MM/DD/YYYY')) AS latest_order
FROM "sample";

-- Memeriksa nilai minimum dan maksimum Sales, Quantity, Profit
SELECT
    MIN("Sales") AS min_sales,
    MAX("Sales") AS max_sales,
    MIN("Quantity") AS min_quantity,
    MAX("Quantity") AS max_quantity,
    MIN("Profit") AS min_profit,
    MAX("Profit") AS max_profit
FROM "sample";


-- 3. TABLE CREATION
-- Membuat tabel customers
DROP TABLE IF EXISTS customers;

CREATE TABLE customers AS
SELECT DISTINCT
    "Customer ID",
    "Customer Name",
    "Segment",
    "Country"
FROM "sample";

-- Membuat tabel orders
DROP TABLE IF EXISTS orders;

CREATE TABLE orders AS
SELECT
    "Order ID",
    "Order Date",
    "Ship Date",
    "Ship Mode",
    "Customer ID",
    "Sales",
    "Quantity",
    "Profit"
FROM "sample";


-- 4. TABLE VALIDATION
-- Memeriksa jumlah data pada tabel
SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_orders
FROM orders;

-- Memeriksa duplikasi Customer ID
SELECT
    "Customer ID",
    COUNT(*) AS total
FROM customers
GROUP BY "Customer ID"
HAVING COUNT(*) > 1;
