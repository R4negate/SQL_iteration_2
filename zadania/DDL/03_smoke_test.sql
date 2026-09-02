-- 03_smoke_test.sql
-- Cel: szybko sprawdzic, czy schemat i dane zostaly poprawnie przygotowane.

SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema = 'course'
ORDER BY table_name;

SELECT 'customers' AS table_name, COUNT(*) AS rows_count FROM course.customers
UNION ALL
SELECT 'products' AS table_name, COUNT(*) AS rows_count FROM course.products
UNION ALL
SELECT 'orders' AS table_name, COUNT(*) AS rows_count FROM course.orders
UNION ALL
SELECT 'order_items' AS table_name, COUNT(*) AS rows_count FROM course.order_items;

