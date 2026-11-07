-- PROJECT 2: CUSTOMER RETENTION & MARKETING ANALYTICS


CREATE DATABASE IF NOT EXISTS project_2_retail;
USE project_2_retail;

CREATE TABLE IF NOT EXISTS online_retail_ii (
    invoice       VARCHAR(20),
    stock_code    VARCHAR(30),
    description   TEXT,
    quantity      INT,
    invoice_date  DATETIME,
    unit_price    DECIMAL(12,4),
    customer_id   VARCHAR(20) NULL,
    country       VARCHAR(100),
    line_total    DECIMAL(14,4),
    invoice_type  VARCHAR(30)
);

DESCRIBE online_retail_ii;

SELECT COUNT(*) AS current_rows
FROM online_retail_ii;


SELECT COUNT(*) AS total_rows
FROM online_retail_ii;

SELECT * FROM online_retail_ii
LIMIT 10;

SELECT MIN(invoice_date) AS first_invoice_date,
    MAX(invoice_date) AS last_invoice_date
FROM online_retail_ii;



SELECT
    COUNT(DISTINCT invoice) AS distinct_invoices,
    COUNT(DISTINCT NULLIF(TRIM(customer_id), '')) AS distinct_known_customers,
    COUNT(DISTINCT stock_code) AS distinct_products,
    COUNT(DISTINCT country) AS distinct_countries
FROM online_retail_ii;



SELECT
    SUM(invoice IS NULL OR TRIM(invoice) = '') AS missing_invoice,
    SUM(stock_code IS NULL OR TRIM(stock_code) = '') AS missing_stock_code,
    SUM(description IS NULL OR TRIM(description) = '') AS missing_description,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(invoice_date IS NULL) AS missing_invoice_date,
    SUM(unit_price IS NULL) AS missing_unit_price,
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customer_id,
    SUM(country IS NULL OR TRIM(country) = '') AS missing_country,
    SUM(line_total IS NULL) AS missing_line_total,
    SUM(invoice_type IS NULL OR TRIM(invoice_type) = '') AS missing_invoice_type
FROM online_retail_ii;



SELECT
    SUM(quantity < 0) AS negative_quantity_rows,
    SUM(unit_price = 0) AS zero_price_rows,
    SUM(unit_price < 0) AS negative_price_rows,
    SUM(invoice LIKE 'C%') AS cancellation_invoice_rows
FROM online_retail_ii;



SELECT LOWER(TRIM(invoice_type)) AS invoice_type,
    COUNT(*) AS transaction_rows
FROM online_retail_ii
GROUP BY LOWER(TRIM(invoice_type))
ORDER BY transaction_rows DESC;


SELECT * FROM online_retail_ii
WHERE quantity < 0 OR unit_price <= 0 OR invoice LIKE 'C%'
LIMIT 50;


SELECT COUNT(*) AS rows_checked,SUM( ABS(line_total - (quantity * unit_price)) > 0.01) AS rows_with_line_total_difference
FROM online_retail_ii
WHERE quantity IS NOT NULL AND unit_price IS NOT NULL AND line_total IS NOT NULL;



SELECT invoice, stock_code, quantity,invoice_date,unit_price,customer_id,COUNT(*) AS repeated_line_count
FROM online_retail_ii GROUP BY invoice,stock_code,quantity,invoice_date,unit_price,customer_id
HAVING COUNT(*) > 1 ORDER BY repeated_line_count DESC LIMIT 100;



CREATE OR REPLACE VIEW retail_transactions AS
SELECT
    NULLIF(TRIM(invoice), '') AS invoice,
    NULLIF(TRIM(stock_code), '') AS stock_code,
    NULLIF(TRIM(description), '') AS description,
    quantity,
    invoice_date,
    unit_price,
    NULLIF(TRIM(customer_id), '') AS customer_id,
    NULLIF(TRIM(country), '') AS country,
    line_total AS source_line_total,
    quantity * unit_price AS calculated_line_total,
    LOWER(TRIM(invoice_type)) AS invoice_type,
    CASE
        WHEN TRIM(invoice) LIKE 'C%' THEN 'Cancellation'
        WHEN quantity < 0 THEN 'Return / Adjustment'
        WHEN quantity > 0 AND unit_price > 0 THEN 'Sale'
        ELSE 'Other / Review'
    END AS transaction_status
FROM online_retail_ii;




CREATE OR REPLACE VIEW retail_sales_clean AS
SELECT
    invoice,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country,
    calculated_line_total AS sales_amount
FROM retail_transactions
WHERE customer_id IS NOT NULL
  AND invoice IS NOT NULL
  AND invoice_date IS NOT NULL
  AND quantity > 0
  AND unit_price > 0
  AND invoice NOT LIKE 'C%'
  AND invoice_type = 'sale';

SELECT COUNT(*) AS clean_sales_rows
FROM retail_sales_clean;

SELECT * FROM retail_sales_clean
LIMIT 10;



SELECT
    ROUND(SUM(sales_amount), 2) AS total_sales_revenue,
    COUNT(DISTINCT invoice) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(quantity) AS total_units_sold
FROM retail_sales_clean;


SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS sales_month,
    ROUND(SUM(sales_amount), 2) AS monthly_revenue,
    COUNT(DISTINCT invoice) AS monthly_orders
FROM retail_sales_clean
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
ORDER BY sales_month;



-- Top 10 countries by revenue.
SELECT
    country,
    ROUND(SUM(sales_amount), 2) AS revenue,
    COUNT(DISTINCT invoice) AS orders,
    COUNT(DISTINCT customer_id) AS customers
FROM retail_sales_clean
GROUP BY country
ORDER BY revenue DESC
LIMIT 10;

-- Top 10 products by revenue.
SELECT
    stock_code,
    MAX(description) AS product_description,
    ROUND(SUM(sales_amount), 2) AS revenue,
    SUM(quantity) AS units_sold
FROM retail_sales_clean
GROUP BY stock_code
ORDER BY revenue DESC
LIMIT 10;

-- Overall average order value.
SELECT
    ROUND(
        SUM(sales_amount) / NULLIF(COUNT(DISTINCT invoice), 0),
        2
    ) AS average_order_value
FROM retail_sales_clean;

-- Monthly average order value.
SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS sales_month,
    ROUND(
        SUM(sales_amount) / NULLIF(COUNT(DISTINCT invoice), 0),
        2
    ) AS average_order_value
FROM retail_sales_clean
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
ORDER BY sales_month;




-- Top 10 customers by revenue.
SELECT
    customer_id,
    ROUND(SUM(sales_amount), 2) AS customer_revenue,
    COUNT(DISTINCT invoice) AS order_count,
    SUM(quantity) AS units_purchased
FROM retail_sales_clean
GROUP BY customer_id
ORDER BY customer_revenue DESC
LIMIT 10;

-- Order count by customer.
SELECT
    customer_id,
    COUNT(DISTINCT invoice) AS order_count
FROM retail_sales_clean
GROUP BY customer_id
ORDER BY order_count DESC;

-- First and latest purchase dates for each customer.
SELECT
    customer_id,
    MIN(invoice_date) AS first_purchase_date,
    MAX(invoice_date) AS latest_purchase_date,
    COUNT(DISTINCT invoice) AS order_count,
    ROUND(SUM(sales_amount), 2) AS total_revenue
FROM retail_sales_clean
GROUP BY customer_id
ORDER BY first_purchase_date;

-- Customer contribution to total sales revenue.
SELECT
    customer_id,
    ROUND(SUM(sales_amount), 2) AS customer_revenue,
    ROUND(
        100 * SUM(sales_amount) /
        (SELECT SUM(sales_amount) FROM retail_sales_clean),
        2
    ) AS revenue_share_pct
FROM retail_sales_clean
GROUP BY customer_id
ORDER BY revenue_share_pct DESC
LIMIT 20;


-- One-time versus repeat customers.
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time customer'
        ELSE 'Repeat customer'
    END AS customer_type,
    COUNT(*) AS number_of_customers
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS order_count
    FROM retail_sales_clean
    GROUP BY customer_id
) AS customer_orders
GROUP BY customer_type
ORDER BY customer_type;

-- Repeat purchase rate.
SELECT
    COUNT(*) AS total_customers,
    SUM(order_count > 1) AS repeat_customers,
    ROUND(
        100.0 * SUM(order_count > 1) / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_purchase_rate_pct
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS order_count
    FROM retail_sales_clean
    GROUP BY customer_id
) AS customer_orders;

-- Customers who purchased in more than one calendar month.
SELECT
    customer_id,
    COUNT(DISTINCT DATE_FORMAT(invoice_date, '%Y-%m')) AS active_months,
    COUNT(DISTINCT invoice) AS order_count,
    ROUND(SUM(sales_amount), 2) AS total_revenue
FROM retail_sales_clean
GROUP BY customer_id
HAVING COUNT(DISTINCT DATE_FORMAT(invoice_date, '%Y-%m')) > 1
ORDER BY active_months DESC, total_revenue DESC;

--  Monthly active customers.
SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM retail_sales_clean
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
ORDER BY sales_month;


--  COHORT RETENTION ANALYSIS


WITH customer_first_purchase AS (
    SELECT
        customer_id,
        DATE_SUB(
            DATE(MIN(invoice_date)),
            INTERVAL DAYOFMONTH(MIN(invoice_date)) - 1 DAY
        ) AS cohort_month
    FROM retail_sales_clean
    GROUP BY customer_id
),
customer_active_months AS (
    SELECT DISTINCT
        customer_id,
        DATE_SUB(
            DATE(invoice_date),
            INTERVAL DAYOFMONTH(invoice_date) - 1 DAY
        ) AS activity_month
    FROM retail_sales_clean
),
cohort_activity AS (
    SELECT
        f.cohort_month,
        a.customer_id,
        TIMESTAMPDIFF(
            MONTH,
            f.cohort_month,
            a.activity_month
        ) AS months_since_first_purchase
    FROM customer_first_purchase f
    JOIN customer_active_months a
      ON f.customer_id = a.customer_id
),
cohort_counts AS (
    SELECT
        cohort_month,
        months_since_first_purchase,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM cohort_activity
    GROUP BY cohort_month, months_since_first_purchase
),
cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_size
    FROM customer_first_purchase
    GROUP BY cohort_month
)
SELECT
    c.cohort_month,
    c.months_since_first_purchase,
    s.cohort_size,
    c.active_customers,
    ROUND(
        100.0 * c.active_customers / NULLIF(s.cohort_size, 0),
        2
    ) AS retention_rate_pct
FROM cohort_counts c
JOIN cohort_sizes s
  ON c.cohort_month = s.cohort_month
ORDER BY c.cohort_month, c.months_since_first_purchase;


--
SELECT
    CASE
        WHEN customer_revenue >= 1000 THEN 'High value'
        WHEN customer_revenue >= 250 THEN 'Medium value'
        ELSE 'Low value'
    END AS customer_segment,
    COUNT(*) AS number_of_customers,
    ROUND(SUM(customer_revenue), 2) AS segment_revenue
FROM (
    SELECT
        customer_id,
        SUM(sales_amount) AS customer_revenue
    FROM retail_sales_clean
    GROUP BY customer_id
) AS customer_spend
GROUP BY customer_segment
ORDER BY segment_revenue DESC;




SELECT
    customer_id,
    MAX(invoice_date) AS last_purchase_date,
    DATEDIFF(
        (SELECT DATE(MAX(invoice_date)) FROM retail_sales_clean),
        DATE(MAX(invoice_date))
    ) AS days_since_last_purchase,
    COUNT(DISTINCT invoice) AS order_count,
    ROUND(SUM(sales_amount), 2) AS customer_revenue
FROM retail_sales_clean
GROUP BY customer_id
HAVING DATEDIFF(
    (SELECT DATE(MAX(invoice_date)) FROM retail_sales_clean),
    DATE(MAX(invoice_date))
) > 90
ORDER BY days_since_last_purchase DESC;

--  Revenue and customer count by country.

SELECT
    country,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(sales_amount), 2) AS revenue,
    ROUND(
        100 * SUM(sales_amount) /
        (SELECT SUM(sales_amount) FROM retail_sales_clean),
        2
    ) AS revenue_share_pct
FROM retail_sales_clean
GROUP BY country
ORDER BY revenue DESC;




WITH customer_rfm AS (
    SELECT
        customer_id,
        DATEDIFF(
            (SELECT DATE(MAX(invoice_date)) + INTERVAL 1 DAY
             FROM retail_sales_clean),
            DATE(MAX(invoice_date))
        ) AS recency_days,
        COUNT(DISTINCT invoice) AS frequency_orders,
        SUM(sales_amount) AS monetary_value
    FROM retail_sales_clean
    GROUP BY customer_id
),
rfm_scores AS (
    SELECT
        customer_id,
        recency_days,
        frequency_orders,
        monetary_value,
        6 - NTILE(5) OVER (
            ORDER BY recency_days ASC, customer_id
        ) AS recency_score,
        NTILE(5) OVER (
            ORDER BY frequency_orders ASC, customer_id
        ) AS frequency_score,
        NTILE(5) OVER (
            ORDER BY monetary_value ASC, customer_id
        ) AS monetary_score
    FROM customer_rfm
)
SELECT
    customer_id,
    recency_days,
    frequency_orders,
    monetary_value,
    recency_score,
    frequency_score,
    monetary_score,
    CONCAT(
        recency_score,
        frequency_score,
        monetary_score
    ) AS rfm_score,
    CASE
        WHEN recency_score >= 4
         AND frequency_score >= 4
         AND monetary_score >= 4
            THEN 'Champions'
        WHEN recency_score >= 3
         AND frequency_score >= 4
            THEN 'Loyal Customers'
        WHEN recency_score >= 4
         AND frequency_score <= 2
            THEN 'New / Promising'
        WHEN recency_score <= 2
         AND frequency_score >= 3
            THEN 'At Risk'
        ELSE 'Needs Attention'
    END AS rfm_segment
FROM rfm_scores
ORDER BY monetary_value DESC;
