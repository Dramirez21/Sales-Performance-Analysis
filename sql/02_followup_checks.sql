-- What are the product names in the products table?
SELECT * FROM products;

-- Nulls in key columns, by stage
SELECT deal_stage,
       COUNT(*) AS deals,
       COUNT(*) - COUNT(account)     AS null_account,
       COUNT(*) - COUNT(product)     AS null_product,
       COUNT(*) - COUNT(sales_agent) AS null_agent
FROM sales_pipeline
GROUP BY deal_stage;

-- Deal values by stage
SELECT deal_stage,
       MIN(close_value) AS min_value,
       MAX(close_value) AS max_value,
       SUM(close_value) AS total_value,
       ROUND(AVG(close_value)) AS avg_value
FROM sales_pipeline
WHERE close_value IS NOT NULL
GROUP BY deal_stage;

-- Any deal closing before it was engaged?
SELECT COUNT(*) AS close_before_engage
FROM sales_pipeline
WHERE close_date < engage_date;

-- First look at the trend: Won revenue by month
SELECT strftime(close_date, '%Y-%m') AS month,
       COUNT(*) AS deals,
       SUM(close_value) AS revenue
FROM sales_pipeline
WHERE deal_stage = 'Won'
GROUP BY 1
ORDER BY 1;