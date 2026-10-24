-- 1. Revenue by product
SELECT product, series, list_price,
       COUNT(*) AS deals,
       SUM(close_value) AS revenue,
       ROUND(AVG(close_value)) AS avg_deal,
       ROUND(100.0 * SUM(close_value) / SUM(SUM(close_value)) OVER (), 1) AS pct_of_revenue
FROM won_deals
GROUP BY product, series, list_price
ORDER BY revenue DESC;

-- 2. Price realization: average close value vs list price
SELECT product, list_price,
       ROUND(AVG(close_value)) AS avg_close_value,
       ROUND(100.0 * AVG(close_value) / list_price, 1) AS pct_of_list
FROM won_deals
GROUP BY product, list_price
ORDER BY pct_of_list;

-- 3. Revenue by account sector
SELECT sector,
       COUNT(DISTINCT account) AS accounts,
       COUNT(*) AS deals,
       SUM(close_value) AS revenue,
       ROUND(AVG(close_value)) AS avg_deal,
       ROUND(100.0 * SUM(close_value) / SUM(SUM(close_value)) OVER (), 1) AS pct_of_revenue
FROM won_deals
GROUP BY sector
ORDER BY revenue DESC;

-- 4. Revenue by regional office and manager
SELECT regional_office, manager,
       COUNT(DISTINCT sales_agent) AS agents,
       COUNT(*) AS deals,
       SUM(close_value) AS revenue,
       ROUND(AVG(close_value)) AS avg_deal
FROM won_deals
GROUP BY regional_office, manager
ORDER BY revenue DESC;

-- 5. Top 10 sales agents
SELECT sales_agent, manager,
       COUNT(*) AS deals,
       SUM(close_value) AS revenue,
       ROUND(AVG(close_value)) AS avg_deal
FROM won_deals
GROUP BY sales_agent, manager
ORDER BY revenue DESC
LIMIT 10;

-- 6. Customer concentration: top 10 accounts
WITH acct AS (
    SELECT account, SUM(close_value) AS revenue
    FROM won_deals
    GROUP BY account
)
SELECT account, revenue,
       ROUND(100.0 * revenue / SUM(revenue) OVER (), 1) AS pct_of_revenue,
       ROUND(100.0 * SUM(revenue) OVER (ORDER BY revenue DESC) / SUM(revenue) OVER (), 1) AS cumulative_pct
FROM acct
ORDER BY revenue DESC
LIMIT 10;

-- 7. Monthly trend with month-over-month growth and average deal size
WITH monthly AS (
    SELECT strftime(close_date, '%Y-%m') AS month,
           COUNT(*) AS deals,
           SUM(close_value) AS revenue
    FROM won_deals
    GROUP BY 1
)
SELECT month, deals, revenue,
       ROUND(1.0 * revenue / deals) AS avg_deal,
       ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
             / LAG(revenue) OVER (ORDER BY month), 1) AS mom_growth_pct
FROM monthly
ORDER BY month;

-- 8. Quarterly trend
SELECT CONCAT(year(close_date), '-Q', quarter(close_date)) AS quarter,
       COUNT(*) AS deals,
       SUM(close_value) AS revenue,
       ROUND(AVG(close_value)) AS avg_deal
FROM won_deals
GROUP BY 1
ORDER BY 1;