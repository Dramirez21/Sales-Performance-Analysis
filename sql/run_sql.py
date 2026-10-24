import sys
import duckdb

con = duckdb.connect("data/processed/sales.duckdb")
sql_text = open(sys.argv[1], encoding="utf-8").read()

for stmt in [s.strip() for s in sql_text.split(";") if s.strip()]:
    print("\n>>>", stmt.splitlines()[0])
    rel = con.sql(stmt)
    if rel is not None:
        rel.show(max_width=200, max_rows=100)

con.close()