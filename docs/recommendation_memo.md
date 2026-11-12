# Memo: Where 311 Misses Its Deadlines, and What to Fix First

**To:** Director, 311 Customer Service, City of San Antonio (hypothetical)
**From:** Khizrali Kradiya
**Data:** Open Data SA, 311 Service Calls, cases opened Nov 7, 2025 – Nov 6, 2026 (499,732 cases)

## Summary
Over the past year, **10.2% of 311 requests (about 51,000) missed their service-level deadline.** The misses are not spread evenly. They concentrate in a few request types, a large aged backlog, and cases that enter the system without a clear owner or location. Three targeted fixes address the biggest sources.

## Recommendation 1: Re-triage four Animal Care request types
**Finding:** Animal Care Services handles 15.5% of requests but accounts for **35% of all late cases** (17,913). Most of its cases close fast (median 0.3 days); the misses come from a handful of types:

| Request type | Late rate | Late cases |
|---|---:|---:|
| Aggressive animal (non-critical) | 30.3% | 4,746 |
| Animal neglect | 37.0% | 3,485 |
| Trapped/confined animal | 57.3% | 3,044 |
| Animal bite (non-critical) | 53.7% | 1,395 |

These four types make up about **71% of Animal Care's late cases**. Non-critical bites take a median of 10.6 days to close, which is a public-safety concern.

**Action:** Review the priority level, deadlines and staffing assigned to these four types, starting with bites.
**Impact:** Halving the late rate on these four types would remove about 6,300 late cases, roughly **12% of the city's total**.

## Recommendation 2: Run a backlog sprint for code enforcement
**Finding:** Development Services has **14,603 open cases (56% of all open cases)**. **7,268 have been open more than 90 days**; the median open case is 89 days old. Overgrown yard/trash, vacant property and alley maintenance cases make up most of it.

**Action:** Run a time-boxed backlog sprint on cases older than 90 days, and add an automatic flag at 60 days so cases are escalated before they age out.
**Measure:** Count of open cases over 90 days, tracked monthly.

## Recommendation 3: Require an owner and a location at intake
**Finding:** Resident requests with no council district are **33.8% late**, about 3x the rate of any district (8.0–11.7%). Cases with no department assigned (1,261) are 97% late, and the 683 still open have a median age of **303 days**. Nobody owns them.

**Action:** Require a validated address and an assigned department before a case is created, and send any case without an owner to a daily review queue.
**Measure:** Unassigned-district and unknown-department cases should trend toward zero.

## Also worth noting
- **Districts are served fairly evenly.** Late rates for resident requests range from 8.0% (D7) to 11.7% (D5).
- **For further analysis (not recommended yet):**
  - Phone is 52% of requests and runs slightly later than web (10.9% vs. 8.9%), but the gap may reflect different request types.
  - Late rates peak in December (14.5%) and June (12.2%). Staffing data would be needed to confirm a seasonal cause.

## Limitations
Late rates for the most recent months are understated, because some open cases may become late later. "Late" uses the city's own flag, which matches a recomputed deadline check about 97% of the time. See `data_quality_report.md`.
