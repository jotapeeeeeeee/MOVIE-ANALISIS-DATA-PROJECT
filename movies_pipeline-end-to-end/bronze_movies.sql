-- Bronze Layer: Raw movie data ingestion
-- Source: movies.default.movie_data
-- Layer: Bronze (preserve raw data with basic filtering)

CREATE OR REFRESH MATERIALIZED VIEW bronze_movies
COMMENT "Raw movie data ingested from movies.default.movie_data"
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
  current_timestamp() AS ingest_timestamp,
  'movies.default.movie_data' AS source_file_path
FROM movies.default.movie_data
WHERE id IS NOT NULL;

