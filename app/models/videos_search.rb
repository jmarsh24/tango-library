class VideosSearch < ApplicationRecord
  include PgSearch::Model

  self.primary_key = :video_id

  pg_search_scope(
    :search,
    against: :description,
    ignoring: :accents,
    using: {
      tsearch: {
        dictionary: "unaccentdict",
        tsvector_column: "tsv_document",
        prefix: true,
      }
    }
  )

  def self.refresh
    Scenic.database.refresh_materialized_view(
      :videos_searches,
      concurrently: false,
      cascade: false
    )
  end

  def readonly?
    true
  end
end