-- Bronze Layer: Raw top-rated movie data ingestion
-- Source: movies.default.top_rated_movies_1
-- Layer: Bronze (preserve raw data with basic filtering)

CREATE OR REFRESH MATERIALIZED VIEW bronze_top_rated_movies
COMMENT "Raw top-rated movie data ingested from movies.default.top_rated_movies_1"
TBLPROPERTIES (
  "quality" = "bronze",
  "domain" = "entertainment"
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
  popularity,
  rating,
  current_timestamp() AS ingest_timestamp,
  'movies.default.top_rated_movies_1' AS source_file_path
FROM movies.default.top_rated_movies_1
WHERE id IS NOT NULL;

