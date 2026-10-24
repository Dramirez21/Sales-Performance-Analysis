SELECT s.sales_agent, s.manager, s.regional_office
FROM sales_teams s
LEFT JOIN sales_pipeline p ON s.sales_agent = p.sales_agent
GROUP BY ALL
HAVING COUNT(p.opportunity_id) = 0;
