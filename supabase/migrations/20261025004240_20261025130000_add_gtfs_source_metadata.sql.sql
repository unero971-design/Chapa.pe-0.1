/*
# Add source metadata for verified transit data

1. Purpose
- The previous catalog was assembled from Truxdi pages and later supplemented
  with estimated points. This migration adds fields that identify the source and
  dataset date for the replacement TMT GTFS catalog.

2. Modified table
- `routes`
- `data_source`: provider name and feed format.
- `data_source_url`: public source page for the feed.
- `data_dataset_id`: immutable MobilityDatabase dataset identifier.
- `data_updated_at`: timestamp supplied by the dataset publisher/archive.

3. Security
- No new tables or policies are created. Existing public read policy and grants
  remain unchanged.

4. Important note
- These fields deliberately expose that the currently verifiable feed is dated
  November 18, 2024. The application must not label it as a 2026 feed until the
  official provider publishes a newer dataset.
*/

ALTER TABLE routes ADD COLUMN IF NOT EXISTS data_source text;
ALTER TABLE routes ADD COLUMN IF NOT EXISTS data_source_url text;
ALTER TABLE routes ADD COLUMN IF NOT EXISTS data_dataset_id text;
ALTER TABLE routes ADD COLUMN IF NOT EXISTS data_updated_at timestamptz;
