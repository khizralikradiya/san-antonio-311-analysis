# 311 Service Performance – Business Requirements

> Draft – rewrite in your own words before publishing.

## Stakeholder
Director of 311 Customer Service, City of San Antonio (hypothetical client), plus department leads for Animal Care Services, Development Services and Solid Waste Management.

## Business problem
311 handles roughly half a million requests a year, and about 1 in 10 misses its service-level deadline (SLA). Leadership needs to know where those misses concentrate so it can target staffing, routing and process fixes where they will matter most.

## Business questions
1. Which departments and request types miss SLA deadlines most often, and in the largest numbers?
2. How large and how old is the open backlog, and who owns it?
3. Is service consistent across council districts?
4. How do volume and late rates change by month and by intake channel (phone, web, staff work order)?

## KPIs and definitions
| KPI | Definition |
|---|---|
| Cases | Requests opened Nov 7, 2025 – Nov 6, 2026 |
| Late rate | % of cases where the city's `Late (Yes/No)` flag = YES |
| Share of all late cases | A group's late cases ÷ all late cases |
| Days to close | Closed date − opened date, closed cases with a valid close date only |
| Open backlog age | Calendar days from opened date to data pull (Nov 7, 2026) |
| Aged backlog | Open cases older than 90 days |

## Scope
- **In:** all 311 service calls opened in the report window (499,732 cases after cleaning).
- **Out:** cases opened before Nov 7, 2025 that appear in the file only because they were updated during the year (13,232 rows); SAPD and other non-311 data.
- **Limitation:** late rates for the most recent months are understated, because some still-open cases may become late later.

## Data source
Open Data SA, "311 Service Calls – All Service Calls" CSV (512,964 rows) and the 311 data dictionary: https://data.sanantonio.gov/dataset/service-calls

## Deliverables
1. Data quality report (`docs/data_quality_report.md`)
2. SQL cleaning and analysis scripts (`sql/`)
3. Tableau Public dashboard
4. One-page recommendation memo
