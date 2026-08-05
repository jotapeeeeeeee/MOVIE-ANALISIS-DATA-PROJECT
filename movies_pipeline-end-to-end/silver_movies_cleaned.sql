-- Silver Layer: Cleaned and validated movie data with derived metrics
-- Source: LIVE.bronze_movies
-- Layer: Silver (apply validation constraints and derive business fields)

CREATE OR REFRESH MATERIALIZED VIEW silver_movies_cleaned(
  CONSTRAINT valid_vote_average EXPECT (vote_average BETWEEN 0 AND 10) ON VIOLATION DROP ROW,
  CONSTRAINT valid_vote_count EXPECT (vote_count >= 0) ON VIOLATION DROP ROW,
  CONSTRAINT valid_release_date EXPECT (release_date IS NOT NULL) ON VIOLATION DROP ROW
)
COMMENT "Cleaned and validated movie data with derived metrics from bronze_movies"
TBLPROPERTIES (
  "quality" = "silver",
  "domain" = "entertainment",
  "delta.enableChangeDataFeed" = "true",
  "delta.enableRowTracking" = "true"
)
AS SELECT
  id,
  title,
  original_language,
  overview,
  release_date,
  original_title,
  vote_average,
  vote_count,
  YEAR(CAST(release_date AS DATE)) AS year_released,
  CASE
    WHEN title IS NULL OR TRIM(title) = '' THEN 'MISSING_TITLE'
    WHEN vote_average < 0 OR vote_average > 10 THEN 'INVALID_VOTE_AVERAGE'
    WHEN vote_count < 0 THEN 'INVALID_VOTE_COUNT'
    WHEN release_date IS NULL THEN 'MISSING_RELEASE_DATE'
    ELSE 'CLEAN'
  END AS data_quality_flag,
  current_timestamp() AS audit_timestamp,
  'bronze_movies' AS source_system
FROM LIVE.bronze_movies;

