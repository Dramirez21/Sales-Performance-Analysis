-- Fix misspellings in accounts
CREATE OR REPLACE VIEW clean_accounts AS
SELECT * REPLACE (
    CASE WHEN sector = 'technolgy' THEN 'technology' ELSE sector END AS sector,
    CASE WHEN office_location = 'Philipines' THEN 'Philippines' ELSE office_location END AS office_location
)
FROM accounts;

-- Fix product name so it matches the products table
CREATE OR REPLACE VIEW clean_pipeline AS
SELECT * REPLACE (
    CASE WHEN product = 'GTXPro' THEN 'GTX Pro' ELSE product END AS product
)
FROM sales_pipeline;

-- One row per won deal with product, account, and team details
CREATE OR REPLACE VIEW won_deals AS
SELECT
    p.opportunity_id,
    p.sales_agent,
    s.manager,
    s.regional_office,
    p.product,
    pr.series,
    pr.sales_price AS list_price,
    p.account,
    a.sector,
    a.office_location AS account_country,
    p.engage_date,
    p.close_date,
    p.close_value
FROM clean_pipeline p
JOIN products pr ON p.product = pr.product
JOIN clean_accounts a ON p.account = a.account
JOIN sales_teams s ON p.sales_agent = s.sales_agent
WHERE p.deal_stage = 'Won';

-- Reconciliation check: should show 4238 deals and 10005534 revenue
SELECT COUNT(*) AS won_deals, SUM(close_value) AS revenue FROM won_deals;