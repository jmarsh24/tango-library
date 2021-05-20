require "rails_helper"

RSpec.describe "Videos::Index", type: :system do
  describe "registered user flow" do
    it "login existing account, shows header, edit user page, add resource...",
       js: true do
      set_up_videos
      generate_existing_user
      visit root_path
      shows_page_navigation
      shows_search_bar
      shows_page_footer
      login
      shows_header_logged_in
      add_new_video
      add_new_channel
      add_new_playlist
      edit_user_page
      open_filters
      performs_a_search
      performs_autocomplete_search
      reset_page
      open_filters
      select_leader_filter
      close_filters
      select_video
      shows_edit_button
      logout
    end
  end

  describe "unregistered user flow" do
    it "creates account, shows header, edit user page, add resource...",
       js: true do
      set_up_videos
      visit root_path
      shows_page_navigation
      shows_search_bar
      shows_page_footer
      create_account
      logout
      login
      shows_header_logged_in
      add_new_video
      add_new_channel
      add_new_playlist
      edit_user_page
      open_filters
      performs_a_search
      performs_autocomplete_search
      reset_page
      open_filters
      select_leader_filter
      close_filters
      logout
    end
  end

  def video_title_collection
    page.all("div.video-title").map(&:text)
  end

  def set_up_videos
    leader = create(:leader, name: "Leader Name")
    @video = create(:video, :display, title: "expected_result", popularity: "1", leader: leader)
    create(:video, :display, title: "video_b", popularity: "2")
  end

  def shows_page_navigation
    expect(page).to have_link("Add Channel", href: channels_path)
    expect(page).to have_link("Add Playlist", href: playlists_path)
    expect(page).to have_link("Add Video", href: new_video_path)
    expect(page).to have_content("Sign up")
    expect(page).to have_content("Login")
    expect(page).to have_link("Sign up", href: new_user_registration_path)
    expect(page).to have_link("Login", href: new_user_session_path)
  end

  def shows_search_bar
    expect(page).to have_css("input#query")
    expect(page).to have_css("button.searchButton")
  end

  def shows_page_footer
    expect(page).to have_content("TangoTubeTV App | Powered by Youtube API")
    expect(page).to have_link("Privacy Policy", href: privacy_path)
    expect(page).to have_link("Terms of Service", href: terms_path)
    expect(page).to have_link(
      "G​oogle Privacy Policy",
      href: "http://www.google.com/policies/privacy"
    )
  end

  def generate_existing_user
    create(:user, email: "j.doe@example.com", password: "foobar1")
  end

  def create_account
    click_on("Sign up")
    shows_page_registrations_new
    fill_in(:user_email, with: "j.doe@example.com")
    fill_in(:user_password, with: "foobar1")
    fill_in(:user_password_confirmation, with: "foobar1")
    click_on("Create account")

    expect(page).to have_content("Welcome! You have signed up successfully.")
  end

  def login
    click_on("Login")
    expect(page).to have_content("Create an account")
    expect(page).to have_content("Forgot your password?")
    fill_in(:user_email, with: "j.doe@example.com")
    fill_in(:user_password, with: "foobar1")
    expect(page).to have_content("Remember me")
    expect(page).to have_link(
      "Create an account",
      href: new_user_registration_path
    )
    expect(page).to have_link(
      "Forgot your password?",
      href: new_user_password_path
    )

    click_on("Log in")

    expect(page).to have_content("Signed in successfully.")
  end

  def select_video
    find("a#video-link").click
  end

  def shows_edit_button
    expect(page).to have_link("Edit", href: edit_video_path(@video))
  end

  def shows_page_registrations_new
    expect(page).to have_field("user_email")
    expect(page).to have_field("user_password")
    expect(page).to have_field("user_password_confirmation")
    expect(page).to have_button("Create account")
  end

  def shows_header_logged_in
    expect(page).to have_link("Edit profile", href: edit_user_registration_path)
    expect(page).to have_link("Logout", href: destroy_user_session_path)
  end

  def add_new_video
    click_on("Add Video")
    expect(page).to have_content("Add Video")
    expect(page).to have_content("youtube.com/watch?v=")
    expect(page).to have_field(id: "video_youtube_id")
    expect(page).to have_button("Add New Video")

    fill_in("video_youtube_id", with: "new_youtube_id")
    click_on("Add New Video")

    expect(page).to have_content(
      "Video Sucessfully Added: The video must be approved before the videos are added"
    )
  end

  def add_new_channel
    click_on("Add Channel")
    expect(page).to have_content("All Channels")
    expect(page).to have_content("youtube.com/channel/")
    expect(page).to have_field(id: "channel_channel_id")
    expect(page).to have_button("Add New Channel")

    fill_in("channel_channel_id", with: "new_channel_id")
    click_on("Add New Channel")

    expect(page).to have_content(
      "Channel Sucessfully Added: The channel must be approved before the videos are added"
    )
  end

  def add_new_playlist
    click_on("Add Playlist")
    expect(page).to have_content("All playlists")
    expect(page).to have_content("youtube.com/playlist/")
    expect(page).to have_field(id: "playlist_slug")
    expect(page).to have_button("Add New Playlist")

    fill_in("playlist_slug", with: "new_playlist_id")
    click_on("Add New Playlist")

    expect(page).to have_content(
      "Playlist Sucessfully Added: The playlist must be approved before the videos are added"
    )
  end

  def edit_user_page
    click_on("Edit profile")

    expect(page).to have_content("Edit User")
    expect(page).to have_content("Email")
    expect(page).to have_content("Password confirmation")
    expect(page).to have_content("Current password")

    expect(page).to have_content("Cancel my account")
    visit root_path
  end

  def forgot_your_password_page
    visit new_user_session_path
    expect(page).to have_content("Forgot your password?")

    click_on("Forgot your password?")

    expect(page).to have_content("Email")
    expect(page).to have_content("Forgot your password?")

    expect(page).to have_link("Log in", href: new_user_session_path)
    expect(page).to have_link(
      "Create an account",
      href: new_user_registration_path
    )
  end

  def open_filters
    find(class: "filter-button").click
    expect(page).to have_css("div.filter-container", visible: :all)
  end

  def close_filters
    find(class: "filter-button").click
    expect(page).to have_css("div.filter-container.isHidden", visible: :all)
  end

  def performs_a_search
    find("button", text: "Popularity").click
    expect(page).to have_current_path("/?sort=videos.popularity&direction=asc")
    expect(video_title_collection).to eq(%w[expected_result video_b])
    fill_in("query", with: "expected_result")
    click_on(class: "searchButton")
    expect(page).to have_current_path("/?query=expected_result")
    expect(page).to have_content("1 Result Found")
    expect(video_title_collection).to eq(%w[expected_result])
  end

  def performs_autocomplete_search
    fill_in("query", with: "Leader")
    expect(page).to have_content("Leader Name")
    find(class: "aa-suggestion", text: "Leader Name").click
    expect(page).to have_current_path("/?query=expected_result")
    expect(page).to have_content("1 Result Found")
    expect(video_title_collection).to eq(%w[expected_result])
  end

  def reset_page
    click_on("TangoTube")
    expect(video_title_collection).to eq(%w[expected_result video_b])
    expect(page).to have_current_path("/")
  end

  def select_leader_filter
    find("div.ss-option", text: "Leader Name (1)").click
    expect(page).to have_current_path("/?leader_id=#{@leader.id}")
    expect(video_title_collection).to eq(["expected_result"])
  end

  def logout
    all(class: "navbar-link", text: "Logout").last.click
    expect(page).to have_content("Signed out successfully.")
  end
end
