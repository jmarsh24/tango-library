# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_02_054037) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "ahoy_events", id: false, force: :cascade do |t|
    t.bigserial "id", null: false
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", id: false, force: :cascade do |t|
    t.bigserial "id", null: false
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "channels", force: :cascade do |t|
    t.string "title"
    t.string "channel_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "thumbnail_url"
    t.boolean "imported", default: false
    t.integer "imported_videos_count", default: 0
    t.integer "total_videos_count", default: 0
    t.integer "yt_api_pull_count", default: 0
    t.boolean "reviewed", default: false
    t.integer "videos_count", default: 0, null: false
    t.index ["title"], name: "index_channels_on_title"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.string "city"
    t.string "country"
    t.string "category"
    t.date "start_date"
    t.date "end_date"
    t.boolean "active", default: true
    t.boolean "reviewed", default: false
    t.integer "videos_count", default: 0, null: false
    t.index ["title"], name: "index_events_on_title"
  end

  create_table "followers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "reviewed"
    t.string "nickname"
    t.string "first_name"
    t.string "last_name"
    t.integer "videos_count", default: 0, null: false
    t.index ["name"], name: "index_followers_on_name"
  end

  create_table "leaders", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "reviewed"
    t.string "nickname"
    t.string "first_name"
    t.string "last_name"
    t.integer "videos_count", default: 0, null: false
    t.index ["name"], name: "index_leaders_on_name"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "description"
    t.string "channel_title"
    t.string "channel_id"
    t.string "video_count"
    t.boolean "imported", default: false
    t.bigint "videos_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "reviewed", default: false
    t.index ["user_id"], name: "index_playlists_on_user_id"
    t.index ["videos_id"], name: "index_playlists_on_videos_id"
  end

  create_table "search_suggestions", force: :cascade do |t|
    t.string "term"
    t.integer "popularity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "songs", force: :cascade do |t|
    t.string "genre"
    t.string "title"
    t.string "artist"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "artist_2"
    t.string "composer"
    t.string "author"
    t.date "date"
    t.string "last_name_search"
    t.integer "occur_count", default: 0
    t.integer "popularity", default: 0
    t.boolean "active", default: true
    t.text "lyrics"
    t.integer "el_recodo_song_id"
    t.integer "videos_count", default: 0, null: false
    t.index ["artist"], name: "index_songs_on_artist"
    t.index ["genre"], name: "index_songs_on_genre"
    t.index ["last_name_search"], name: "index_songs_on_last_name_search"
    t.index ["title"], name: "index_songs_on_title"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "title"
    t.string "youtube_id"
    t.bigint "leader_id"
    t.bigint "follower_id"
    t.string "description"
    t.integer "duration"
    t.date "upload_date"
    t.integer "view_count"
    t.string "tags"
    t.bigint "song_id"
    t.string "youtube_song"
    t.string "youtube_artist"
    t.string "acrid"
    t.string "spotify_album_id"
    t.string "spotify_album_name"
    t.string "spotify_artist_id"
    t.string "spotify_artist_id_2"
    t.string "spotify_artist_name"
    t.string "spotify_artist_name_2"
    t.string "spotify_track_id"
    t.string "spotify_track_name"
    t.string "youtube_song_id"
    t.string "isrc"
    t.integer "acr_response_code"
    t.bigint "channel_id"
    t.boolean "scanned_song", default: false
    t.boolean "hidden", default: false
    t.boolean "hd", default: false
    t.integer "popularity", default: 0
    t.integer "like_count", default: 0
    t.integer "dislike_count", default: 0
    t.integer "favorite_count", default: 0
    t.integer "comment_count", default: 0
    t.bigint "event_id"
    t.boolean "scanned_youtube_music", default: false
    t.integer "click_count", default: 0
    t.string "spotify_artist_id_1"
    t.string "spotify_artist_name_1"
    t.string "acr_cloud_artist_name"
    t.string "acr_cloud_artist_name_1"
    t.string "acr_cloud_album_name"
    t.string "acr_cloud_track_name"
    t.index ["acr_cloud_artist_name"], name: "index_videos_on_acr_cloud_artist_name"
    t.index ["acr_cloud_track_name"], name: "index_videos_on_acr_cloud_track_name"
    t.index ["channel_id"], name: "index_videos_on_channel_id"
    t.index ["event_id"], name: "index_videos_on_event_id"
    t.index ["follower_id"], name: "index_videos_on_follower_id"
    t.index ["hd"], name: "index_videos_on_hd"
    t.index ["hidden"], name: "index_videos_on_hidden", where: "(hidden IS FALSE)"
    t.index ["leader_id"], name: "index_videos_on_leader_id"
    t.index ["popularity"], name: "index_videos_on_popularity"
    t.index ["song_id"], name: "index_videos_on_song_id"
    t.index ["spotify_artist_name"], name: "index_videos_on_spotify_artist_name"
    t.index ["spotify_track_name"], name: "index_videos_on_spotify_track_name"
    t.index ["tags"], name: "index_videos_on_tags"
    t.index ["upload_date"], name: "index_videos_on_upload_date"
    t.index ["view_count"], name: "index_videos_on_view_count"
    t.index ["youtube_artist"], name: "index_videos_on_youtube_artist"
    t.index ["youtube_id"], name: "index_videos_on_youtube_id"
    t.index ["youtube_song"], name: "index_videos_on_youtube_song"
  end

end
