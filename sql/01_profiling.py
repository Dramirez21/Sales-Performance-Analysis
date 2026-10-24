import duckdb

con = duckdb.connect("data/processed/sales.duckdb", read_only=True)

queries = {
    "Table structure: sales_pipeline": "DESCRIBE sales_pipeline",

    "Deals by stage": """
        SELECT deal_stage, COUNT(*) AS deals
        FROM sales_pipeline
        GROUP BY deal_stage
        ORDER BY deals DESC
    """,

    "Date ranges": """
        SELECT MIN(engage_date) AS first_engage, MAX(engage_date) AS last_engage,
               MIN(close_date)  AS first_close,  MAX(close_date)  AS last_close
        FROM sales_pipeline
    """,

    "Nulls by stage": """
        SELECT deal_stage,
               COUNT(*) AS deals,
               COUNT(*) - COUNT(engage_date) AS null_engage,
               COUNT(*) - COUNT(close_date)  AS null_close,
               COUNT(*) - COUNT(close_value) AS null_value
        FROM sales_pipeline
        GROUP BY deal_stage
    """,

    "Duplicate opportunity IDs": """
        SELECT opportunity_id, COUNT(*) AS n
        FROM sales_pipeline
        GROUP BY opportunity_id
        HAVING COUNT(*) > 1
    """,

    "Pipeline products with no match in products table": """
        SELECT p.product, COUNT(*) AS deals
        FROM sales_pipeline p
        LEFT JOIN products pr ON p.product = pr.product
        WHERE pr.product IS NULL
        GROUP BY p.product
    """,

    "Pipeline accounts with no match in accounts table": """
        SELECT COUNT(*) AS unmatched_rows
        FROM sales_pipeline p
        LEFT JOIN accounts a ON p.account = a.account
        WHERE a.account IS NULL AND p.account IS NOT NULL
    """,

    "Pipeline agents with no match in sales_teams": """
        SELECT COUNT(*) AS unmatched_rows
        FROM sales_pipeline p
        LEFT JOIN sales_teams s ON p.sales_agent = s.sales_agent
        WHERE s.sales_agent IS NULL
    """,

    "Account sectors (check spellings)": """
        SELECT sector, COUNT(*) AS accounts
        FROM accounts
        GROUP BY sector
        ORDER BY sector
    """,

    "Account countries (check spellings)": """
        SELECT office_location, COUNT(*) AS accounts
        FROM accounts
        GROUP BY office_location
        ORDER BY office_location
    """,
}

for title, sql in queries.items():
    print(f"\n=== {title} ===")
    con.sql(sql).show(max_width=200, max_rows=100)

con.close()