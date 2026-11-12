-- ============================================================
-- San Antonio 311 Service Calls: cleaning + analysis
-- Data: Open Data SA, "All Service Calls" (Nov 7 2025 - Nov 6 2026)
-- Engine: DuckDB (Mac: `brew install duckdb`, then run `duckdb sa311.db`)
-- Put allservicecalls.csv in the same folder you run DuckDB from.
-- ============================================================


-- ---------- STEP 1: LOAD ----------
CREATE OR REPLACE TABLE raw AS
SELECT * FROM read_csv_auto('allservicecalls.csv');

-- Check: should return 512,964
SELECT count(*) FROM raw;


-- ---------- STEP 2: CLEAN ----------
-- Cleaning rules (put these in your README):
--  1. Keep only cases OPENED in the report window (drops ~13K older cases
--     that appear because they were updated during the year).
--  2. Placeholder dates (1899/1900) -> NULL.
--  3. Source labels are inconsistent ('voice_in' vs 'Voice in', 'web' vs 'Web')
--     -> normalized into Phone / Web / Work order / Other.
--  4. Council district 0 -> 'Unassigned' (93% of these are city-staff work orders).
--  5. Missing Dept/Category -> 'Unknown'.
--  6. days_to_close only for CLOSED cases with a valid, non-negative duration.
--  7. "Late" uses the city's own flag (matches a recomputed SLA check 97% of the time).

CREATE OR REPLACE TABLE calls AS
WITH t AS (
  SELECT
    CASEID                                   AS case_id,
    CAST(OPENEDDATETIME AS TIMESTAMP)        AS opened_at,
    CAST(SLA_Date       AS TIMESTAMP)        AS sla_raw,
    CAST(CLOSEDDATETIME AS TIMESTAMP)        AS closed_raw,
    "Late (Yes/No)" = 'YES'                  AS is_late,
    COALESCE(Dept, 'Unknown')                AS dept,
    REASONNAME                               AS reason,
    TYPENAME                                 AS request_type,
    CASESTATUS                               AS status,
    CASE lower(replace(SOURCEID, ' ', '_'))
      WHEN 'voice_in' THEN 'Phone'
      WHEN 'web'      THEN 'Web'
      WHEN 'wom'      THEN 'Work order (city staff)'
      ELSE 'Other'
    END                                      AS source,
    CASE WHEN COUNCIL_DIST = 0 THEN 'Unassigned'
         ELSE concat('D', COUNCIL_DIST) END  AS district,
    COALESCE(Category, 'Unknown')            AS category
  FROM raw
)
SELECT
  case_id, opened_at,
  CASE WHEN sla_raw    >= TIMESTAMP '2000-01-01' THEN sla_raw    END AS sla_due,
  CASE WHEN closed_raw >= TIMESTAMP '2000-01-01' THEN closed_raw END AS closed_at,
  is_late, dept, reason, request_type, status, source, district, category,
  CASE
    WHEN status = 'CLOSED'
     AND closed_raw >= TIMESTAMP '2000-01-01'
     AND closed_raw >= opened_at
    THEN date_diff('second', opened_at, closed_raw) / 86400.0
  END AS days_to_close
FROM t
WHERE opened_at >= TIMESTAMP '2025-11-07'
  AND opened_at <  TIMESTAMP '2026-11-07';

-- Check: ~499,732 rows, ~10.2% late, median ~1.75 days
SELECT count(*)                                AS cases,
       round(avg(is_late::INT) * 100, 1)       AS late_pct,
       round(median(days_to_close), 2)         AS median_days,
       sum(CASE WHEN status = 'OPEN' THEN 1 ELSE 0 END) AS open_cases
FROM calls;


-- ---------- STEP 3: ANALYSIS ----------

-- Q1. Which departments miss the most deadlines?
SELECT dept,
       count(*)                                       AS cases,
       sum(is_late::INT)                              AS late_cases,
       round(avg(is_late::INT) * 100, 1)              AS late_pct,
       round(sum(is_late::INT) * 100.0
             / (SELECT sum(is_late::INT) FROM calls), 1) AS share_of_all_late,
       round(median(days_to_close), 1)                AS median_days
FROM calls
GROUP BY dept
ORDER BY late_cases DESC;

-- Q2. Which request types drive the late cases? (types with 1,000+ cases)
SELECT dept, request_type,
       count(*)                          AS cases,
       sum(is_late::INT)                 AS late_cases,
       round(avg(is_late::INT) * 100, 1) AS late_pct,
       round(median(days_to_close), 1)   AS median_days
FROM calls
GROUP BY dept, request_type
HAVING count(*) >= 1000
ORDER BY late_cases DESC
LIMIT 15;

-- Q3. Open backlog: how old are the cases still open? (data pulled Nov 7, 2026)
SELECT dept,
       count(*) AS open_cases,
       median(date_diff('day', opened_at, TIMESTAMP '2026-11-07')) AS median_age_days,
       sum(CASE WHEN date_diff('day', opened_at, TIMESTAMP '2026-11-07') > 90
                THEN 1 ELSE 0 END) AS open_over_90_days
FROM calls
WHERE status = 'OPEN'
GROUP BY dept
ORDER BY open_cases DESC;

-- Q4. Is service fair across council districts?
--     Resident-reported only (excludes city work orders, which have no district).
SELECT district,
       count(*)                          AS cases,
       round(avg(is_late::INT) * 100, 1) AS late_pct,
       round(median(days_to_close), 1)   AS median_days
FROM calls
WHERE source <> 'Work order (city staff)'
GROUP BY district
ORDER BY late_pct DESC;

-- Q5. Channel mix: phone vs web
SELECT source,
       count(*)                                         AS cases,
       round(count(*) * 100.0 / sum(count(*)) OVER (), 1) AS pct_of_cases,
       round(avg(is_late::INT) * 100, 1)                AS late_pct
FROM calls
GROUP BY source
ORDER BY cases DESC;

-- Q6. Monthly trend
SELECT strftime(opened_at, '%Y-%m')      AS month,
       count(*)                          AS cases,
       round(avg(is_late::INT) * 100, 1) AS late_pct
FROM calls
GROUP BY 1
ORDER BY 1;


-- ---------- STEP 4: EXPORT FOR TABLEAU ----------
-- Clean, row-level file (no addresses) for the dashboard.
COPY calls TO 'sa311_clean.csv' (HEADER, DELIMITER ',');
