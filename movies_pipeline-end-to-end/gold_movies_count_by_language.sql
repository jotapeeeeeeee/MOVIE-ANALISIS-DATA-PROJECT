-- Gold Layer: Movie distribution and ratings by original language
-- Source: LIVE.gold_movies_fact
-- Layer: Gold (language-based aggregation for market analysis)

CREATE OR REFRESH MATERIALIZED VIEW gold_movies_count_by_language
COMMENT "Business aggregation: Movie distribution and ratings by original language"
TBLPROPERTIES (
  "quality" = "gold",
  "domain" = "entertainment"
)
AS SELECT
  original_language,
  COUNT(*) AS movie_count,
  ROUND(AVG(vote_average), 2) AS avg_rating,
  current_timestamp() AS audit_timestamp,
  'gold_aggregation' AS source_system
FROM LIVE.gold_movies_fact
GROUP BY original_language
ORDER BY movie_count DESC;

