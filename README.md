# Sales Performance Analysis: What's Driving Revenue?

An end-to-end analysis of B2B sales performance, using SQL, Python, and
[Power BI / Tableau] to find out which products, customers, and sales
teams drive revenue, and how revenue has trended over time.

## Business Problem

A B2B company sells products to business accounts through a team of sales
agents organized under regional managers. Leadership can see total revenue,
but not what is behind it. Without knowing the drivers, it's hard to decide
where to invest, which products to push, or how to coach the sales team.

**This project answers one question: what's driving sales?**

To answer it, the analysis breaks revenue down into measurable pieces:

1. **Trend:** How has revenue changed over time?
2. **Products:** Which products and product series generate the most revenue?
3. **Customers:** Which account sectors and individual accounts contribute
   disproportionately to revenue?
4. **Sales team:** How do agents, managers, and regional offices compare?
5. **Volume vs. deal size:** Is revenue driven by winning more deals or by
   larger deals?

## Scope

- Revenue analysis uses **closed-won deals only**, since those carry
  realized revenue.
- Deals without dates are excluded from time-based analysis.
- Close dates run from March to December 2017, so trends are
  within-year only (no year-over-year comparison).

## Dataset

[Maven Analytics CRM Sales Opportunities](link-to-dataset): four related
tables (`accounts`, `products`, `sales_teams`, `sales_pipeline`) with
8,800 deals across 85 accounts, 7 products, and 35 sales agents. Of those,
4,238 deals were won, totaling $10,005,534 in revenue.

## Tools

- **SQL (DuckDB):** joins, aggregation, and growth calculations
- **Python (pandas, matplotlib):** data cleaning, trend and driver analysis
- **Excel:** pivot-table validation of key figures
- **[Power BI / Tableau]:** interactive dashboard

## Data Cleaning Decisions

| Issue | Finding | Decision |
|---|---|---|
| Revenue scope | Only Won deals have a close value (Lost = $0) | Revenue analysis uses Won deals only |
| Open and undated deals | 500 Prospecting deals have no dates or values, 1,589 Engaging deals have no close date or value | Excluded from revenue and trend analysis |
| Product name mismatch | `GTXPro` in pipeline (1,480 deals) vs `GTX Pro` in products | Standardized to `GTX Pro` |
| Sector typo | `technolgy` (12 accounts) | Corrected to `technology` |
| Country typo | `Philipines` (1 account) | Corrected to `Philippines` |
| Time span | Close dates run Mar to Dec 2017 | Within-year trends only, no year-over-year |
| Reconciliation | Cleaned `won_deals` view ties to raw Won totals (4,238 deals, $10,005,534) | Verified |

## Key Findings
*Coming soon.*

## Recommendations
*Coming soon.*