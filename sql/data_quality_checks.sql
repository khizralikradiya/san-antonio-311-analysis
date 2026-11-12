-- ============================================================
-- San Antonio 311: data quality checks (run against the raw table)
-- Each row = one check and how many raw rows fail it.
-- ============================================================
WITH r AS (
  SELECT *,
    CAST(OPENEDDATETIME AS TIMESTAMP) AS o,
    CAST(SLA_Date AS TIMESTAMP) AS s,
    CAST(CLOSEDDATETIME AS TIMESTAMP) AS c
  FROM raw
),
checks AS (
  SELECT 'Opened before report window' AS check_name, count(*) FILTER (WHERE o < TIMESTAMP '2025-11-07') AS failing_rows FROM r
  UNION ALL SELECT 'Missing or placeholder SLA date', count(*) FILTER (WHERE s IS NULL OR s < TIMESTAMP '2000-01-01') FROM r
  UNION ALL SELECT 'Closed case with missing/placeholder close date', count(*) FILTER (WHERE CASESTATUS = 'CLOSED' AND (c IS NULL OR c < TIMESTAMP '2000-01-01')) FROM r
  UNION ALL SELECT 'Closed before opened', count(*) FILTER (WHERE c >= TIMESTAMP '2000-01-01' AND c < o) FROM r
  UNION ALL SELECT 'Non-standard source label', count(*) FILTER (WHERE SOURCEID IN ('Voice in', 'Web', 'Voice out')) FROM r
  UNION ALL SELECT 'No council district (0)', count(*) FILTER (WHERE COUNCIL_DIST = 0) FROM r
  UNION ALL SELECT 'Missing department', count(*) FILTER (WHERE Dept IS NULL) FROM r
  UNION ALL SELECT 'Missing category', count(*) FILTER (WHERE Category IS NULL) FROM r
  UNION ALL SELECT 'Missing coordinates', count(*) FILTER (WHERE XCOORD IS NULL) FROM r
  UNION ALL SELECT 'Duplicate case IDs', count(*) - count(DISTINCT CASEID) FROM r
  UNION ALL SELECT 'Late flag disagrees with SLA (closed cases)', count(*) FILTER (
      WHERE CASESTATUS = 'CLOSED' AND c >= TIMESTAMP '2000-01-01' AND s >= TIMESTAMP '2000-01-01'
        AND ((c > s) <> ("Late (Yes/No)" = 'YES'))) FROM r
)
SELECT check_name, failing_rows,
       round(failing_rows * 100.0 / (SELECT count(*) FROM raw), 2) AS pct_of_rows
FROM checks
ORDER BY failing_rows DESC;
