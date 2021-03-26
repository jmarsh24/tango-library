class VideosController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :current_search, only: %i[index show]
  NUMBER_OF_VIDEOS_PER_PAGE = 120

  helper_method :sort_column, :sort_direction

  def index
    @videos_total = Video.not_hidden.size
    @videos = Video.not_hidden
                   .includes(:leader, :follower, :channel, :song, :event)
                   .order("#{sort_column} #{sort_direction}")
                   .filter_videos(filtering_params)

    @videos_paginated = @videos.paginate(page, NUMBER_OF_VIDEOS_PER_PAGE)
    @videos_paginated = @videos_paginated.shuffle if filtering_params.blank?

    @next_page_items = @videos.paginate(page + 1, NUMBER_OF_VIDEOS_PER_PAGE)
    @items_display_count = (@videos.size - (@videos.size - (page * NUMBER_OF_VIDEOS_PER_PAGE).clamp(0, @videos.size)))

    @leaders    = @videos.joins(:leader).pluck("leaders.name").uniq.sort.map(&:titleize)
    @followers  = @videos.joins(:follower).pluck("followers.name").uniq.sort.map(&:titleize)
    @channels   = @videos.joins(:channel).pluck("channels.title").uniq.compact.sort
    @artists    = @videos.joins(:song).pluck("songs.artist").uniq.compact.sort.map(&:titleize)
    @genres     = @videos.joins(:song).pluck("songs.genre").uniq.compact.sort.map(&:titleize).uniq

    respond_to do |format|
      format.html
      format.json do
        render json: { videos:   render_to_string(partial: "videos/index/videos", formats: [:html]),
                       loadmore: render_to_string(partial: "videos/index/load_more", formats: [:html]) }
      end
    end
  end

  def show
    @video = Video.find_by(youtube_id: params[:v])
    @videos_total = Video.not_hidden.size
    videos = if Video.where(song_id: @video.song_id).size > 3
               Video.where(song_id: @video.song_id)
             else
               Video.where(channel_id: @video.channel_id)
             end

    @recommended_videos = videos.where(hidden: false)
                                .where.not(youtube_id: @video.youtube_id)
                                .order("popularity DESC")
                                .limit(3)
    @video.clicked!
  end

  def edit
    @video = Video.find(params[:id])
    @videos_total = Video.not_hidden.size
    videos = if Video.where(song_id: @video.song_id).size > 3
               Video.where(song_id: @video.song_id)
             else
               Video.where(channel_id: @video.channel_id)
             end

    @recommended_videos = videos.where(hidden: false)
                                .where.not(youtube_id: @video.youtube_id)
                                .order("popularity DESC")
                                .limit(3)
  end

  def update
    @video = Video.find(params[:id])
    @video.update(video_params)
    redirect_to watch_path(v: @video.youtube_id)
  end

  private

  def current_search
    @current_search = params[:query]
  end

  def video_params
    params.require(:video).permit(:leader_id, :follower_id, :song_id, :event_id, :hidden, :id)
  end
end
