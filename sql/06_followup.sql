-- 1. Does Dustin Brinkmann's team work GTX Pro in any stage
SELECT p.product, p.deal_stage, COUNT(*) AS deals
FROM clean_pipeline p
JOIN sales_teams s ON p.sales_agent = s.sales_agent
WHERE s.manager = 'Dustin Brinkmann'
GROUP BY p.product, p.deal_stage
ORDER BY p.product, p.deal_stage;

-- 2. Who sells GTK 500 in any stage
SELECT p.sales_agent, s.manager, p.deal_stage, COUNT(*) AS deals
FROM clean_pipeline p
JOIN sales_teams s ON p.sales_agent = s.sales_agent
WHERE p.product = 'GTK 500'
GROUP BY ALL
ORDER BY deals DESC;

-- 3. Closed deals and win rate for the busiest agents
SELECT p.sales_agent, s.manager,
       COUNT(*) AS closed_deals,
       ROUND(100.0 * COUNT(*) FILTER (WHERE p.deal_stage = 'Won') / COUNT(*), 1) AS win_rate_pct
FROM clean_pipeline p
JOIN sales_teams s ON p.sales_agent = s.sales_agent
WHERE p.deal_stage IN ('Won', 'Lost')
GROUP BY p.sales_agent, s.manager
ORDER BY closed_deals DESC
LIMIT 8;