-- Gold Layer: Average movie ratings and counts by release year
-- Source: LIVE.gold_movies_fact
-- Layer: Gold (time-based aggregation for trend analysis)

CREATE OR REFRESH MATERIALIZED VIEW gold_movies_avg_rating_by_year
COMMENT "Business aggregation: Average movie ratings and counts by release year"
TBLPROPERTIES (
  "quality" = "gold",
  "domain" = "entertainment"
)
AS SELECT
  year_released,
  COUNT(*) AS movie_count,
  ROUND(AVG(vote_average), 2) AS avg_rating,
  SUM(vote_count) AS total_votes,
  current_timestamp() AS audit_timestamp,
  'gold_aggregation' AS source_system
FROM LIVE.gold_movies_fact
WHERE vote_average IS NOT NULL
GROUP BY year_released
ORDER BY year_released DESC;

