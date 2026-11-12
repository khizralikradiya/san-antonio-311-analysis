# San Antonio 311 Service Performance Analysis

Analysis of ~500K San Antonio 311 service requests (Nov 2025 – Nov 2026) to find where the city misses its service-level deadlines and what to fix first.

**Tools:** SQL (DuckDB), Tableau Public
**Data:** [Open Data SA – 311 Service Calls](https://data.sanantonio.gov/dataset/service-calls)

## Project structure
```
docs/requirements.md          Stakeholder, business questions, KPI definitions
docs/data_quality_report.md   11 data quality checks and how each was handled
docs/recommendation_memo.md   One-page memo with three recommendations
sql/311_analysis.sql          Load, clean, analyze, export
sql/data_quality_checks.sql   Data quality checks on the raw file
```

## Key findings
_Write 3–5 bullets from your notes._

## Dashboard
[![San Antonio 311 dashboard](https://public.tableau.com/static/images/Sa/SanAntonio311WhereServiceDeadlinesAreMissed/SanAntonio311WhereServiceDeadlinesAreMissed/1.png)](https://public.tableau.com/app/profile/khizrali.kradiya/viz/SanAntonio311WhereServiceDeadlinesAreMissed/SanAntonio311WhereServiceDeadlinesAreMissed)

[Open the interactive dashboard on Tableau Public](https://public.tableau.com/app/profile/khizrali.kradiya/viz/SanAntonio311WhereServiceDeadlinesAreMissed/SanAntonio311WhereServiceDeadlinesAreMissed)

## Recommendations
See [docs/recommendation_memo.md](docs/recommendation_memo.md):
1. Re-triage four Animal Care request types
2. Run a backlog sprint for code enforcement
3. Require an owner and a location at intake

## Limitations
- Recent months' late rates are understated (some open cases may become late).
- Days to close excludes cases with missing or invalid close dates.

## How to reproduce
1. Download "All Service Calls" CSV from Open Data SA into this folder as `allservicecalls.csv`.
2. `duckdb sa311.db` and run `sql/311_analysis.sql`, then `sql/data_quality_checks.sql`.
