-- Gold Layer: Complete movie fact table combining all sources
-- Sources: LIVE.silver_movies_cleaned, LIVE.silver_top_rated_movies_cleaned
-- Layer: Gold (denormalized fact table for analytics)

CREATE OR REFRESH MATERIALIZED VIEW gold_movies_fact
COMMENT "Business aggregation: Complete movie fact table combining all sources"
TBLPROPERTIES (
  "quality" = "gold",
  "domain" = "entertainment",
  "delta.enableChangeDataFeed" = "true"
)
AS SELECT DISTINCT
  id,
  title,
  original_language,
  overview,
  release_date,
  original_title,
  vote_average,
  vote_count,
  year_released,
  data_quality_flag,
  current_timestamp() AS audit_timestamp,
  'gold_aggregation' AS source_system
FROM (
  SELECT
    id,
    title,
    original_language,
    overview,
    release_date,
    original_title,
    vote_average,
    vote_count,
    year_released,
    data_quality_flag
  FROM LIVE.silver_movies_cleaned
  WHERE data_quality_flag = 'CLEAN'
  AND vote_average IS NOT NULL
  
  UNION ALL
  
  SELECT
    id,
    title,
    original_language,
    overview,
    release_date,
    original_title,
    vote_average,
    vote_count,
    year_released,
    data_quality_flag
  FROM LIVE.silver_top_rated_movies_cleaned
  WHERE data_quality_flag = 'CLEAN'
  AND vote_average IS NOT NULL
);

