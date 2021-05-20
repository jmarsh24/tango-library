require "rails_helper"

RSpec.describe "Videos::Index", type: :system do
  it "shows videos, display and populates filters", js: true do
    setup_videos
    visit root_path
    show_filters
    sort_by_popularity
    shows_videos
    sorts_videos

    display_filters
    links_to_videos

    populate_filters
    filter_by_hd
  end

  it "filters videos", js: true do
    setup_videos
    visit root_path
    show_filters
    filters_correctly
  end

  def setup_videos
    @leader = create(:leader, name: "leader_name")
    @follower = create(:follower, name: "follower_name")
    @song_a = create(:song, artist: "artist_name_a", last_name_search: "A", title: "song_title_a", genre: "genre_a")
    song_b = create(:song, artist: "artist_name_b", last_name_search: "B", title: "song_title_b", genre: "genre_b")
    song_c = create(:song, artist: "artist_name_c", last_name_search: "C", title: "song_title_c", genre: "genre_c")
    @event_a = create(:event, title: "event_a")
    event_b = create(:event, title: "event_b")
    event_c = create(:event, title: "event_c")
    @channel_a = create(:channel, title: "channel_a")
    channel_b = create(:channel, title: "channel_b")
    channel_c = create(:channel, title: "channel_c")
    create(
      :video,
      :display,
      title: "video_a",
      view_count: "1",
      like_count: "1",
      popularity: "3",
      upload_date: "2000-01-01",
      youtube_id: "youtube_id_a",
      duration: "30",
      hd: "0",
      song: @song_a,
      channel: @channel_a,
      event: @event_a,
      leader: @leader
    )
    create(
      :video,
      :display,
      title: "video_b",
      view_count: "2",
      like_count: "2",
      popularity: "2",
      upload_date: "1999-01-01",
      youtube_id: "youtube_id_b",
      duration: "60",
      hd: "1",
      song: song_b,
      channel: channel_b,
      event: event_b,
      follower: @follower
    )
    create(
      :video,
      :display,
      title: "video_c",
      view_count: "3",
      like_count: "3",
      popularity: "1",
      upload_date: "1998-01-01",
      youtube_id: "youtube_id_c",
      duration: "90",
      hd: "1",
      song: song_c,
      channel: channel_c,
      event: event_c
    )
  end

  def display_filters
    display_hd_all_buttons
    display_sort_options
  end

  def sorts_videos
    sort_by_song_title
    sort_by_channel
    sort_by_orchestra
    sort_by_view_count
    sort_by_upload_date
  end

  def filters_correctly
    filters_by_genre
    filters_by_leader
    filters_by_follower
    filters_by_orchestra
    filters_by_year
  end

  def filters_by_genre
    filter_by_genre_alone
    filter_by_genre_and_hd
    filter_by_genre_and_leader
    filter_by_genre_and_follower
    filter_by_genre_and_follower_and_hd
    filter_by_genre_and_orchestra
    filter_by_genre_and_orchestra_and_hd
    filter_by_genre_and_year
    filter_by_genre_and_year_and_hd
  end

  def filters_by_leader
    filter_by_leader_alone
    filter_by_leader_and_genre
    filter_by_leader_and_orchestra
    filter_by_leader_and_year
  end

  def filters_by_follower
    filter_by_follower_alone
    filter_by_follower_and_hd
    filter_by_follower_and_genre
    filter_by_follower_and_genre_and_hd
    filter_by_follower_and_orchestra
    filter_by_follower_and_orchestra_and_hd
    filter_by_follower_and_year
    filter_by_follower_and_year_and_hd
  end

  def filters_by_orchestra
    filter_by_orchestra_alone
    filter_by_orchestra_and_hd
    filter_by_orchestra_and_genre
    filter_by_orchestra_and_genre_and_hd
    filter_by_orchestra_and_leader
    filter_by_orchestra_and_follower
    filter_by_orchestra_and_follower_and_hd
    filter_by_orchestra_and_year
    filter_by_orchestra_and_year_and_hd
  end

  def filters_by_year
    filter_by_year_alone
    filter_by_year_and_hd
    filter_by_year_and_genre
    filter_by_year_and_genre_and_hd
    filter_by_year_and_leader
    filter_by_year_and_follower
    filter_by_year_and_follower_and_hd
    filter_by_year_and_orchestra
    filter_by_year_and_orchestra_and_hd
  end

  def links_to_videos
    filter_by_video_song_id
    filter_by_video_channel_id
    filter_by_video_event_id
    visit_video_thumbnail_link
    visit_video_title_link
  end

  def paginated_videos
    load_more_button_present
    load_more_button_hidden
  end

  def shows_videos
    display_video_thumbnails
    display_video_thumbnail_details
    display_channel_titles
    display_video_song
    display_video_event_title
    display_video_metadata
  end

  def filter_collection
    page.all("div.ss-option").map(&:text)
  end

  def video_thumbnail_collection
    page.all("img.thumbnail-image").map { |img| img["src"] }
  end

  def video_thumnbail_details_collection
    page.all("div.thumbnail").map { |data| data["data-duration"] }
  end

  def video_title_collection
    page.all("div.video-title").map(&:text)
  end

  def video_metadata_collection
    page.all("div.video-metadata").map(&:text)
  end

  def video_event_title_collection
    page.all("div.video-event").map(&:text)
  end

  def video_channel_titles_collection
    page.all("div.video-channel").map(&:text)
  end

  def video_metadata_collection
    page.all("div.video-metadata").map(&:text)
  end

  def video_song_collection
    page.all("div.video-song").map(&:text)
  end

  def filter_by_genre_a
    find("div.ss-option", text: "Genre A (1)").click
    wait_for_filters
  end

  def filter_by_genre_b
    find("div.ss-option", text: "Genre B (1)").click
    wait_for_filters
  end

  def filter_by_leader
    find("div.ss-option", text: "Leader Name (1)").click
    wait_for_filters
  end

  def filter_by_follower
    find("div.ss-option", text: "Follower Name (1)").click
    wait_for_filters
  end

  def filter_by_orchestra_a
    find("div.ss-option", text: "Artist Name A (1)").click
    wait_for_filters
  end

  def filter_by_orchestra_b
    find("div.ss-option", text: "Artist Name B (1)").click
    wait_for_filters
  end

  def filter_by_year_2000
    find("div.ss-option", text: "2000 (1)").click
    wait_for_filters
  end

  def filter_by_year_1999
    find("div.ss-option", text: "1999 (1)").click
    wait_for_filters
  end

  def sort_by_popularity
    click_on("Popularity")
    expect(page).to have_current_path("/?sort=videos.popularity&direction=asc")
    click_on("Popularity")
    expect(page).to have_current_path("/?sort=videos.popularity&direction=desc")
  end

  def display_video_thumbnails
    expect(video_thumbnail_collection).to eq(
      %w[
        https://img.youtube.com/vi/youtube_id_a/hqdefault.jpg
        https://img.youtube.com/vi/youtube_id_b/hqdefault.jpg
        https://img.youtube.com/vi/youtube_id_c/hqdefault.jpg
      ]
    )
  end

  def display_video_thumbnail_details
    expect(video_thumnbail_details_collection).to eq(
      ["00:30", "HD 01:00", "HD 01:30"]
    )
  end

  def display_channel_titles
    expect(video_channel_titles_collection).to eq(
      %w[channel_a channel_b channel_c]
    )
  end

  def display_video_song
    expect(video_song_collection).to eq(
      [
        "Song Title A - Artist Name A - Genre A",
        "Song Title B - Artist Name B - Genre B",
        "Song Title C - Artist Name C - Genre C"
      ]
    )
  end

  def display_video_event_title
    expect(video_event_title_collection).to eq(
      ["Event A", "Event B", "Event C"]
    )
  end

  def display_video_metadata
    expect(video_metadata_collection).to eq(
      [
        "January 2000 • 1 views • 1 likes",
        "January 1999 • 2 views • 2 likes",
        "January 1998 • 3 views • 3 likes"
      ]
    )
  end

  def display_hd_all_buttons
    expect(page).to have_content("HD")
    expect(page).to have_content("All")
  end

  def display_sort_options
    expect(page).to have_content("Song Title")
    expect(page).to have_content("Orchestra")
    expect(page).to have_content("Channel")
    expect(page).to have_content("View Count")
    expect(page).to have_content("Upload Date")
  end

  def populate_filters
    click_on("Popularity")

    expect(page).to have_select("genre-filter",
      with_options: ["", "Genre A (1)", "Genre B (1)", "Genre C (1)"],
      visible: :all
    )
    expect(page).to have_select(
      "leader-filter",
      with_options: ["", "Leader Name (1)"],
      visible: :all
    )
    expect(page).to have_select(
      "follower-filter",
      with_options: ["", "Follower Name (1)"],
      visible: :all
    )
    expect(page).to have_select(
      "orchestra-filter",
      with_options: [
        "",
        "Artist Name A (1)",
        "Artist Name B (1)",
        "Artist Name C (1)"
      ],
      visible: :all
    )
    expect(page).to have_select(
      "year-filter",
      with_options: ["", "2000 (1)", "1999 (1)", "1998 (1)"],
      visible: :all
    )
  end

  def show_filters
    if page.has_css?("div.filter-container.isHidden", visible: :all)
      click_on("Filters")
      expect(page).to have_css("div.filter-container:not(.isHidden)", visible: :all)
    end
  end

  def hide_filters
    if page.has_css?("div.filter-container.not(.isHidden)", visible: :all)
      click_on("Filters")
      expect(page).to have_css("div.filter-container:not(.isHidden)", visible: :all)
    end
  end

  def wait_for_filters
    expect(page).to have_css("div.ss-content.ss-open.disabled")
    expect(page).to have_css("div.ss-content.ss-open:not(.disabled)")
    expect(page).to have_css("div.ss-content.ss-open")
  end

  def sort_by_song_title
    click_on("Song Title")
    expect(page).to have_current_path("/?sort=songs.title&direction=desc")
    expect(video_title_collection).to eq(%w[video_c video_b video_a])
    click_on("Song Title")
    expect(page).to have_current_path("/?sort=songs.title&direction=asc")
    expect(video_title_collection).to eq(%w[video_a video_b video_c])
  end

  def sort_by_channel
    click_on("Channel")
    expect(page).to have_current_path("/?sort=videos.channel_id&direction=desc")
    expect(video_title_collection).to eq(%w[video_c video_b video_a])
    click_on("Channel")
    expect(page).to have_current_path("/?sort=videos.channel_id&direction=asc")
    expect(video_title_collection).to eq(%w[video_a video_b video_c])
  end

  def sort_by_view_count
    click_on("View Count")
    expect(page).to have_current_path("/?sort=videos.view_count&direction=desc")
    expect(video_title_collection).to eq(%w[video_c video_b video_a])
    click_on("View Count")
    expect(page).to have_current_path("/?sort=videos.view_count&direction=asc")
    expect(video_title_collection).to eq(%w[video_a video_b video_c])
  end

  def sort_by_upload_date
    click_on("Upload Date")
    expect(page).to have_current_path("/?sort=videos.upload_date&direction=desc")
    expect(video_title_collection).to eq(%w[video_a video_b video_c])
    click_on("Upload Date")
    expect(page).to have_current_path("/?sort=videos.upload_date&direction=asc")
    expect(video_title_collection).to eq(%w[video_c video_b video_a])
  end

  def sort_by_orchestra
    click_on("Orchestra")
    expect(page).to have_current_path("/?sort=songs.last_name_search&direction=desc")
    expect(video_title_collection).to eq(%w[video_c video_b video_a])
    click_on("Orchestra")
    expect(page).to have_current_path("/?sort=songs.last_name_search&direction=asc")
    expect(video_title_collection).to eq(%w[video_a video_b video_c])
  end

  def load_more_button_present
    stub_const("Video::Search::NUMBER_OF_VIDEOS_PER_PAGE", 2)
    visit root_path
    expect(page).to have_content("Displaying 2 / 3 Results")
    click_on("Load More")
    expect(page).not_to have_content("Load More")
    expect(page).to have_content("Displaying 3 / 3 Results")
  end

  def load_more_button_hidden
    stub_const("Video::Search::NUMBER_OF_VIDEOS_PER_PAGE", 5)
    visit root_path
    expect(page).not_to have_content("Load More")
    expect(page).to have_content("Displaying 3 / 3 Results")
  end

  def filter_by_hd
    click_on("HD")
    expect(video_title_collection).to include("video_b")
    expect(video_title_collection).to include("video_c")
    expect(video_title_collection).not_to include("video_a")
  end

  def filter_by_video_song_id
    click_link("Song Title A - Artist Name A - Genre A")
    expect(page).to have_current_path("/?song_id=#{@song_a.id}")
    expect(page).to have_content("1 Result Found")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_video_channel_id
    click_link("channel_a")
    expect(page).to have_current_path("/?channel_id=#{@channel_a.id}")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_video_event_id
    click_link("Event A")
    expect(page).to have_current_path("/?event_id=#{@event_a.id}")
    expect(video_title_collection).to eq(["video_a"])
  end

  def visit_video_thumbnail_link
    all("a#video-link").first.click
    expect(page).to have_current_path("/watch?v=youtube_id_a")
    visit root_path
  end

  def visit_video_title_link
    click_on("video_a")
    expect(page).to have_current_path("/watch?v=youtube_id_a")
    visit root_path
  end

  def filter_by_genre_alone
    visit root_path
    filter_by_genre_a
    expect(page).to have_current_path("/?genre=genre_a")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_genre_and_hd
    visit root_path
    filter_by_genre_b
    expect(page).to have_current_path("/?genre=genre_b")
    click_on("HD")
    expect(page).to have_current_path("/?genre=genre_b&hd=1")
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_genre_and_leader
    visit root_path
    filter_by_genre_a
    expect(page).to have_current_path("/?genre=genre_a")
    filter_by_leader
    expect(page).to have_current_path("/?genre=genre_a&leader=leader_name")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_genre_and_follower
    visit root_path
    filter_by_genre_b
    expect(page).to have_current_path("/?genre=genre_b")
    filter_by_follower
    expect(page).to have_current_path(
      "/?genre=genre_b&follower=follower_name"
    )
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_genre_and_follower_and_hd
    visit root_path
    filter_by_genre_b
    expect(page).to have_current_path("/?genre=genre_b")
    filter_by_follower
    expect(page).to have_current_path(
      "/?genre=genre_b&follower=follower_name"
    )
    click_on("HD")
    expect(page).to have_current_path(
      "/?follower=follower_name&genre=genre_b&hd=1"
    )
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_genre_and_orchestra
    visit root_path
    filter_by_genre_a
    expect(page).to have_current_path("/?genre=genre_a")
    filter_by_orchestra_a
    expect(page).to have_current_path("/?genre=genre_a&orchestra=artist_name_a")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_genre_and_orchestra_and_hd
    visit root_path
    filter_by_genre_b
    expect(page).to have_current_path("/?genre=genre_b")
    filter_by_orchestra_b
    expect(page).to have_current_path("/?genre=genre_b&orchestra=artist_name_b")
    click_on("HD")
    expect(page).to have_current_path("/?genre=genre_b&orchestra=artist_name_b&hd=1")
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_genre_and_year
    visit root_path
    filter_by_genre_a
    expect(page).to have_current_path("/?genre=genre_a")
    filter_by_year_2000
    expect(page).to have_current_path("/?genre=genre_a&year=2000")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_genre_and_year_and_hd
    visit root_path
    filter_by_genre_b
    expect(page).to have_current_path("/?genre=genre_b")
    filter_by_year_1999
    expect(page).to have_current_path("/?genre=genre_b&year=1999")
    click_on("HD")
    expect(page).to have_current_path("/?genre=genre_b&year=1999&hd=1")
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_leader_alone
    visit root_path
    filter_by_leader
    expect(page).to have_current_path("/?leader=leader_name")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_leader_and_genre
    visit root_path
    filter_by_leader
    expect(page).to have_current_path("/?leader=leader_name")
    filter_by_genre_a
    expect(page).to have_current_path("/?leader=leader_name&genre=genre_a")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_leader_and_orchestra
    visit root_path
    filter_by_leader
    expect(page).to have_current_path("/?leader=leader_name")
    filter_by_orchestra_a
    expect(page).to have_current_path(
      "/?leader=leader_name&orchestra=artist_name_a"
    )
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_leader_and_year
    visit root_path
    filter_by_leader
    expect(page).to have_current_path("/?leader=leader_name")
    filter_by_year_2000
    expect(page).to have_current_path("/?leader=leader_name&year=2000")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_follower_alone
    visit root_path
    filter_by_follower
    expect(page).to have_current_path("/?follower=follower_name")
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_follower_and_hd
    visit root_path
    filter_by_follower
    click_on("HD")
    expect(page).to have_current_path("/?hd=1&follower=follower_name")
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_follower_and_genre
    visit root_path
    filter_by_follower
    expect(page).to have_current_path("/?follower=follower_name")
    filter_by_genre_b
    expect(page).to have_current_path(
      "/?follower=follower_name&genre=genre_b"
    )
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_follower_and_genre_and_hd
    visit root_path
    filter_by_follower
    expect(page).to have_current_path("/?follower=follower_name")
    filter_by_genre_b
    expect(page).to have_current_path("/?follower_id=#{@follower.id}&genre=genre_b")
    click_on("HD")
    expect(page).to have_current_path(
      "/?follower=follower_name&hd=1&genre=genre_b"
    )

    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_follower_and_orchestra
    visit root_path
    filter_by_follower
    expect(page).to have_current_path("/?follower=follower_name")
    filter_by_orchestra_b
    expect(page).to have_current_path(
      "/?follower=follower_name&orchestra=artist_name_b"
    )
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_follower_and_orchestra_and_hd
    visit root_path
    filter_by_follower
    expect(page).to have_current_path("/?follower=follower_name")
    filter_by_orchestra_b
    expect(page).to have_current_path("/?follower_id=#{@follower.id}&orchestra=artist_name_b")
    click_on("HD")
    expect(page).to have_current_path(
      "/?follower=follower_name&hd=1&orchestra=artist_name_b"
    )
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_follower_and_year
    visit root_path
    filter_by_follower
    expect(page).to have_current_path("/?follower=follower_name")
    filter_by_year_1999
    expect(page).to have_current_path("/?follower=follower_name&year=1999")
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_follower_and_year_and_hd
    visit root_path
    filter_by_follower
    expect(page).to have_current_path("/?follower=follower_name")
    filter_by_year_1999
    expect(page).to have_current_path("/?follower_id=#{@follower.id}&year=1999")
    click_on("HD")
    expect(page).to have_current_path(
      "/?follower=follower_name&hd=1&year=1999"
    )
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_orchestra_alone
    visit root_path
    filter_by_orchestra_a
    expect(page).to have_current_path("/?orchestra=artist_name_a")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_orchestra_and_hd
    visit root_path
    filter_by_orchestra_b
    expect(page).to have_current_path("/?orchestra=artist_name_b")
    click_on("HD")
    expect(page).to have_current_path("/?orchestra=artist_name_b&hd=1")
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_orchestra_and_genre
    visit root_path
    filter_by_orchestra_a
    expect(page).to have_current_path("/?orchestra=artist_name_a")
    filter_by_genre_a
    expect(page).to have_current_path("/?orchestra=artist_name_a&genre=genre_a")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_orchestra_and_genre_and_hd
    visit root_path
    filter_by_orchestra_b
    expect(page).to have_current_path("/?orchestra=artist_name_b")
    filter_by_genre_b
    click_on("HD")
    expect(page).to have_current_path("/?orchestra=artist_name_b&genre=genre_b&hd=1")
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_orchestra_and_leader
    visit root_path
    filter_by_orchestra_a
    expect(page).to have_current_path("/?orchestra=artist_name_a")
    filter_by_leader
    expect(video_title_collection).to eq(["video_a"])
    expect(page).to have_current_path(
      "/?orchestra=artist_name_a&leader=leader_name"
    )
  end

  def filter_by_orchestra_and_follower
    visit root_path
    filter_by_orchestra_b
    expect(page).to have_current_path("/?orchestra=artist_name_b")
    filter_by_follower
    expect(page).to have_current_path(
      "/?orchestra=artist_name_b&follower=follower_name"
    )
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_orchestra_and_follower_and_hd
    visit root_path
    filter_by_orchestra_b
    expect(page).to have_current_path("/?orchestra=artist_name_b")
    filter_by_follower
    expect(page).to have_current_path("/?orchestra=artist_name_b&follower_id=#{@follower.id}")
    click_on("HD")
    expect(page).to have_current_path(
      "/?hd=1&orchestra=artist_name_b&follower=follower_name"
    )
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_orchestra_and_year
    visit root_path
    filter_by_orchestra_a
    expect(page).to have_current_path("/?orchestra=artist_name_a")
    filter_by_year_2000
    expect(page).to have_current_path("/?orchestra=artist_name_a&year=2000")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_orchestra_and_year_and_hd
    visit root_path
    filter_by_orchestra_b
    expect(page).to have_current_path("/?orchestra=artist_name_b")
    filter_by_year_1999
    expect(page).to have_current_path("/?orchestra=artist_name_b&year=1999")
    click_on("HD")
    expect(page).to have_current_path("/?orchestra=artist_name_b&year=1999&hd=1")
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_year_alone
    visit root_path
    filter_by_year_2000
    expect(page).to have_current_path("/?year=2000")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_year_and_hd
    visit root_path
    filter_by_year_1999
    expect(page).to have_current_path("/?year=1999")
    click_on("HD")
    expect(page).to have_current_path("/?year=1999&hd=1")
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_year_and_genre
    visit root_path
    filter_by_year_2000
    expect(page).to have_current_path("/?year=2000")
    filter_by_genre_a
    expect(page).to have_current_path("/?year=2000&genre=genre_a")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_year_and_genre_and_hd
    visit root_path
    filter_by_year_1999
    expect(page).to have_current_path("/?year=1999")
    filter_by_genre_b
    expect(page).to have_current_path("/?year=1999&genre=genre_b")
    click_on("HD")
    expect(page).to have_current_path("/?year=1999&genre=genre_b&hd=1")
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_year_and_leader
    visit root_path
    filter_by_year_2000
    expect(page).to have_current_path("/?year=2000")
    filter_by_leader
    expect(page).to have_current_path("/?year=2000&leader=leader_name")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_year_and_follower
    visit root_path
    filter_by_year_1999
    expect(page).to have_current_path("/?year=1999")
    filter_by_follower
    expect(page).to have_current_path("/?year=1999&follower=follower_name")
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_year_and_follower_and_hd
    visit root_path
    filter_by_year_1999
    expect(page).to have_current_path("/?year=1999")
    filter_by_follower
    expect(page).to have_current_path("/?year=1999&follower_id=#{@follower.id}")
    click_on("HD")
    expect(page).to have_current_path(
      "/?hd=1&year=1999&follower=follower_name"
    )
    expect(video_title_collection).to eq(["video_b"])
  end

  def filter_by_year_and_orchestra
    visit root_path
    filter_by_year_2000
    expect(page).to have_current_path("/?year=2000")
    filter_by_orchestra_a
    expect(page).to have_current_path("/?year=2000&orchestra=artist_name_a")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_year_and_orchestra_and_hd
    visit root_path
    filter_by_year_1999
    expect(page).to have_current_path("/?year=1999")
    filter_by_orchestra_b
    expect(page).to have_current_path("/?year=1999&orchestra=artist_name_b")
    click_on("HD")
    expect(page).to have_current_path("/?year=1999&orchestra=artist_name_b&hd=1")
    expect(video_title_collection).to eq(["video_b"])
  end
end
