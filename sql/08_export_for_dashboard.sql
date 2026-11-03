COPY (
    SELECT w.*,
           date_trunc('month', close_date)::DATE AS close_month,
           CONCAT(year(close_date), '-Q', quarter(close_date)) AS close_quarter,
           ((month(close_date) - 1) % 3) + 1 AS month_in_quarter,
           date_diff('day', engage_date, close_date) AS days_to_close
    FROM won_deals w
) TO 'data/processed/won_deals.csv' (HEADER, DELIMITER ',');

COPY (
    SELECT p.opportunity_id, p.sales_agent, s.manager, s.regional_office,
           p.product, p.deal_stage, p.engage_date, p.close_date, p.close_value
    FROM clean_pipeline p
    JOIN sales_teams s ON p.sales_agent = s.sales_agent
    WHERE p.deal_stage IN ('Won', 'Lost')
) TO 'data/processed/closed_deals.csv' (HEADER, DELIMITER ',');
