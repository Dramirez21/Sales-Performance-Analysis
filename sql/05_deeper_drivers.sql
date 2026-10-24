-- 1. Win rate by product (closed deals only)
SELECT product,
       COUNT(*) FILTER (WHERE deal_stage = 'Won')  AS won,
       COUNT(*) FILTER (WHERE deal_stage = 'Lost') AS lost,
       ROUND(100.0 * COUNT(*) FILTER (WHERE deal_stage = 'Won') / COUNT(*), 1) AS win_rate_pct
FROM clean_pipeline
WHERE deal_stage IN ('Won', 'Lost')
GROUP BY product
ORDER BY win_rate_pct DESC;

-- 2. Win rate by manager
SELECT s.manager, s.regional_office,
       COUNT(*) AS closed_deals,
       ROUND(100.0 * COUNT(*) FILTER (WHERE p.deal_stage = 'Won') / COUNT(*), 1) AS win_rate_pct
FROM clean_pipeline p
JOIN sales_teams s ON p.sales_agent = s.sales_agent
WHERE p.deal_stage IN ('Won', 'Lost')
GROUP BY s.manager, s.regional_office
ORDER BY win_rate_pct DESC;

-- 3. Product mix: top agent vs. lowest-avg-deal team vs. everyone else
WITH grouped AS (
    SELECT CASE WHEN sales_agent = 'Darcel Schlecht' THEN 'Darcel Schlecht'
                WHEN manager = 'Dustin Brinkmann' THEN 'Team Dustin Brinkmann'
                ELSE 'Everyone else' END AS grp,
           product, close_value
    FROM won_deals
)
SELECT grp, product,
       COUNT(*) AS deals,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY grp), 1) AS pct_of_group_deals,
       SUM(close_value) AS revenue
FROM grouped
GROUP BY grp, product
ORDER BY grp, revenue DESC;

-- 4. Sales cycle length by product (days from engage to close)
SELECT product, COUNT(*) AS deals,
       ROUND(AVG(date_diff('day', engage_date, close_date)), 1) AS avg_days_to_close
FROM won_deals
GROUP BY product
ORDER BY avg_days_to_close DESC;

-- 5. Where in the quarter deals close (complete quarters only, Apr to Dec)
SELECT ((month(close_date) - 1) % 3) + 1 AS month_in_quarter,
       COUNT(*) AS deals,
       SUM(close_value) AS revenue
FROM won_deals
WHERE close_date >= DATE '2017-04-01'
GROUP BY 1
ORDER BY 1;

-- 6. Revenue per account by sector
SELECT sector,
       COUNT(DISTINCT account) AS accounts,
       SUM(close_value) AS revenue,
       ROUND(SUM(close_value) / COUNT(DISTINCT account)) AS revenue_per_account
FROM won_deals
GROUP BY sector
ORDER BY revenue_per_account DESC;