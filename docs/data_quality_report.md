# Data Quality Report – San Antonio 311 Service Calls

Raw file: 512,964 rows. Checks run with `sql/data_quality_checks.sql` (DuckDB).

| Check | Failing rows | % of rows | How it was handled |
|---|---:|---:|---|
| No council district (0) | 91,470 | 17.83% | Labeled "Unassigned". 93% are city-staff work orders; excluded those when comparing districts. |
| Non-standard source label | 84,423 | 16.46% | Normalized `voice_in`/`Voice in` → Phone, `web`/`Web` → Web, `WOM` → Work order. |
| Opened before report window | 13,232 | 2.58% | Removed – these older cases appear only because they were updated during the year. |
| Late flag disagrees with SLA (closed cases) | 12,313 | 2.40% | Kept the city's official flag; documented the gap (flag matches a recomputed SLA check ~97% of the time). |
| Missing coordinates | 2,427 | 0.47% | Kept; not needed for district-level analysis. |
| Missing or placeholder SLA date | 1,746 | 0.34% | 1899/1900 placeholder dates set to NULL. |
| Missing department | 1,261 | 0.25% | Labeled "Unknown" – these cases have no owner (median open age 303 days). |
| Closed case with missing/placeholder close date | 780 | 0.15% | Excluded from days-to-close calculations. |
| Missing category | 304 | 0.06% | Labeled "Unknown". |
| Closed before opened | 2 | 0.00% | Excluded from days-to-close calculations. |
| Duplicate case IDs | 0 | 0.00% | Passed – no duplicates. |

## Key takeaway
Data quality affects service, not just reporting: resident requests with no council district were **33.8% late**, about 3x the rate of any district.
