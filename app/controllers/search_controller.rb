class SearchController < ApplicationController
  ALLOWED_FILTERS = %w[leader follower channel genre orchestra song_id query hd event_id].freeze
  NUMBER_OF_VIDEOS_PER_PAGE = 120

  def index
    @collection = Video.all

    @filters = filter_params.dig(:filters)&.to_h

    query = params[:q] || ""
    search_options = { sort:       params[:sort],
                       filters:    @filters,
                       weights:    %i[title director cast],
                       with_score: true,
                       facets:     ALLOWED_FILTERS,
                       highlight:  true }

    @results = Video.search(query, search_options)
    @facets = Video.facets(@collection, query, search_options)
    @sort_by = sort_by
    @sort_options = [%w[Relevance _score_desc],
                     ["Title A-Z", "title_asc"],
                     ["Title Z-A", "title_desc"],
                     %w[Other other]]

    @filters = OpenStruct.new @filters

    @results_page = @results.offset(per_page * (page - 1)).limit(per_page)
  end

  def permitted_params
    params.permit(:q, sort: %i[field direction]).merge(filter_params)
  end
  helper_method :permitted_params

  def filter_params
    params.permit(filters: allowed_filters_params)
  end

  def track_search
    Searchjoy::Search.create(
      search_type:   "Title",
      query:         params[:q],
      results_count: @results.count,
      user_id:       1
    )
  end

  def allowed_filters_params
    ALLOWED_FILTERS.map do |f|
      { f.to_s.to_sym => [] }
    end.reduce({}, :merge)
  end

  def sort_by
    case params.dig(:sort, :field)
    when "title"
      "title_#{params.dig(:sort, :direction)}"
    when "_score"
      "_score_desc"
    else
      "other"
    end
  end

  def page
    @page ||= params.permit(:page).fetch(:page, 1).to_i
  end
end

# "songs.title",
# "songs.artist",
# "songs.genre",
# "leaders.name",
# "followers.name",
# "channels.title",
# "videos.upload_date",
# "videos.view_count",
# "songs.last_name_search",
# "videos.popularity"]
