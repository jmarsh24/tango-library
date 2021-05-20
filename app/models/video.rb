class Video < ApplicationRecord
  include Filterable

  SEARCHABLE_COLUMNS = %w[channels.title
                        followers.name
                        leaders.name
                        songs.genre
                        songs.title
                        songs.artist
                        videos.acr_cloud_track_name
                        videos.acr_cloud_artist_name
                        videos.description
                        videos.title
                        videos.youtube_artist
                        videos.youtube_id
                        videos.youtube_song
                        videos.spotify_artist_name
                        videos.spotify_track_name
                        videos.tags].freeze

  validates :youtube_id, presence: true, uniqueness: true

  belongs_to :leader, optional: true, counter_cache: true
  belongs_to :follower, optional: true, counter_cache: true
  belongs_to :song, optional: true, counter_cache: true
  belongs_to :channel, optional: false, counter_cache: true
  belongs_to :event, optional: true, counter_cache: true

  scope :filter_by_orchestra, ->(song_artist) { joins(:song).where("songs.artist ILIKE ?", song_artist)}
  scope :filter_by_genre, ->(song_genre) { joins(:song).where("songs.genre ILIKE ?", song_genre) }
  scope :filter_by_leader, ->(leader) { joins(:leader).where("leaders.name ILIKE ?", leader) }
  scope :filter_by_follower, ->(follower) { joins(:follower).where("followers.name ILIKE ?", follower) }
  scope :filter_by_channel_id, ->(channel_id) { where(channel_id: channel_id) }
  scope :filter_by_event_id, ->(event_id) { where(event_id: event_id) }
  scope :filter_by_song_id, ->(song_id) { where(song_id: song_id) }
  scope :filter_by_hd, ->(boolean) { where(hd: boolean) }
  scope :filter_by_year,->(year) { where("extract(year from upload_date) = ?", year) }
  scope :hidden, -> { where(hidden: true) }
  scope :not_hidden, -> { where(hidden: false) }
  scope :paginate, ->(page, per_page) { offset(per_page * (page - 1)).limit(per_page) }

  # Active Admin scopes
  scope :has_song, -> { where.not(song_id: nil) }
  scope :has_leader, -> { where.not(leader_id: nil) }
  scope :has_follower, -> { where.not(follower_id: nil) }
  scope :missing_follower, -> { where(follower_id: nil) }
  scope :missing_leader, -> { where(leader_id: nil) }
  scope :missing_song, -> { where(song_id: nil) }

  # Youtube Music Scopes
  scope :scanned_youtube_music, -> { where(scanned_youtube_music: true) }
  scope :not_scanned_youtube_music, -> { where(scanned_youtube_music: false) }
  scope :has_youtube_song, -> { where.not(youtube_song: nil) }

  # AcrCloud Response scopes
  scope :successful_acrcloud, -> { where(acr_response_code: 0) }
  scope :not_successful_acrcloud, -> { where(acr_response_code: 1001) }
  scope :scanned_acrcloud, -> { where(acr_response_code: [0, 1001]) }
  scope :not_scanned_acrcloud,
        -> {
          where
            .not(acr_response_code: [0, 1001])
            .or(Video.where(acr_response_code: nil))
        }

  # Attribute Matching Scopes
  scope :with_song_title,
        lambda { |song_title|
          where(
            'unaccent(spotify_track_name) ILIKE unaccent(:song_title)
                                    OR unaccent(youtube_song) ILIKE unaccent(:song_title)
                                    OR unaccent(title) ILIKE unaccent(:song_title)
                                    OR unaccent(description) ILIKE unaccent(:song_title)
                                    OR unaccent(tags) ILIKE unaccent(:song_title)
                                    OR unaccent(acr_cloud_track_name) ILIKE unaccent(:song_title)',
            song_title: "%#{song_title}%"
          )
        }

  scope :with_song_artist_keyword,
        lambda { |song_artist_keyword|
          where(
            'spotify_artist_name ILIKE :song_artist_keyword
                                            OR unaccent(spotify_artist_name_2) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(youtube_artist) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(description) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(title) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(tags) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(spotify_album_name) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(acr_cloud_album_name) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(acr_cloud_artist_name) ILIKE unaccent(:song_artist_keyword)
                                            OR unaccent(acr_cloud_artist_name_1) ILIKE unaccent(:song_artist_keyword)',
            song_artist_keyword: "%#{song_artist_keyword}%"
          )
        }

  scope :with_dancer_name_in_title,
        lambda { |dancer_name|
          where(
            "unaccent(title) ILIKE unaccent(:dancer_name)",
            dancer_name: "%#{dancer_name}%"
          )
        }

  # Combined Scopes

  scope :title_match_missing_leader,
        ->(leader_name) {
          missing_leader.with_dancer_name_in_title(leader_name)
        }
  scope :title_match_missing_follower,
        ->(follower_name) {
          missing_follower.with_dancer_name_in_title(follower_name)
        }

  class << self
    def filter_by_query(query_string)
      sql_query_array = []
      keywords_array_without_stop_words = keywords_array_without_stop_words(query_string)
      keywords_array_without_stop_words.each do |keyword|
        sql_query_array.push(sql_query(keyword))
      end
      left_outer_joins(:song, :leader, :follower, :channel).where(combined_sql_queries(sql_query_array))
    end

    private

    def stop_words
      %w[and or the a an of to " ']
    end

    def stop_words_regex
      "/\b(#{stop_words.join('|')})\b/"
    end

    def keywords_array_without_stop_words(query_string)
      query_string.gsub(stop_words_regex, "").gsub("'", "").to_s.strip.split
    end

    def searchable_column_ignoring_apostrophe(searchable_column)
      "REPLACE(#{searchable_column},'''','')"
    end

    def combined_sql_queries(sql_query_array)
      sql_query_array.flatten.join(") AND (")
    end

    def sql_query(keyword)
      sql_query = []
      SEARCHABLE_COLUMNS.each do |searchable_column|
        sql_query.push("unaccent(#{searchable_column_ignoring_apostrophe(searchable_column)}) ILIKE unaccent('%#{keyword}%')")
      end
      sql_query.join(" OR ")
    end
  end

  def display
    @display ||= Video::Display.new(self)
  end

  def clicked!
    increment(:click_count)
    increment(:popularity)
    save!
  end
end
