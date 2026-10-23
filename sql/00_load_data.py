import duckdb

con = duckdb.connect("data/processed/sales.duckdb")

for table in ["accounts", "products", "sales_teams", "sales_pipeline"]:
    con.execute(f"""
        CREATE OR REPLACE TABLE {table} AS
        SELECT * FROM read_csv_auto('data/raw/{table}.csv')
    """)
    n = con.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
    print(f"{table}: {n} rows")

con.close()
