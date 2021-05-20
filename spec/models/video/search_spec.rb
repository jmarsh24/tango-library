require "rails_helper"

RSpec.describe Video::Search, type: :model do
  describe "#videos" do
    describe "sorting" do
      it "returns videos sorted by songs.last_name_search" do
        song_a = create(:song, last_name_search: "A")
        song_b = create(:song, last_name_search: "B")
        video_a = create(:video, song: song_a)
        video_b = create(:video, song: song_b)
        search_asc =
          described_class.new(
            sorting_params: {
              sort: "songs.last_name_search",
              direction: "ASC"
            }
          )
        search_desc =
          described_class.new(
            sorting_params: {
              sort: "songs.last_name_search",
              direction: "DESC"
            }
          )
        expect(search_asc.videos).to eq [video_b, video_a]
        expect(search_desc.videos).to eq [video_b, video_a]
      end

      it "returns videos sorted by songs.title" do
        song_a = create(:song, title: "A")
        song_b = create(:song, title: "B")
        video_a = create(:video, song: song_a)
        video_b = create(:video, song: song_b)
        search_asc =
          described_class.new(
            sorting_params: {
              sort: "songs.title",
              direction: "ASC"
            }
          )
        search_desc =
          described_class.new(
            sorting_params: {
              sort: "songs.title",
              direction: "DESC"
            }
          )
        expect(search_asc.videos).to eq [video_b, video_a]
        expect(search_desc.videos).to eq [video_b, video_a]
      end

      it "returns videos sorted by upload_date" do
        video_a = create(:video, upload_date: Time.zone.local(2020, 1, 1))
        video_b = create(:video, upload_date: Time.zone.local(2019, 1, 1))
        search_asc =
          described_class.new(
            sorting_params: {
              sort: "videos.upload_date",
              direction: "ASC"
            }
          )
        search_desc =
          described_class.new(
            sorting_params: {
              sort: "videos.upload_date",
              direction: "DESC"
            }
          )
        expect(search_asc.videos).to eq [video_a, video_b]
        expect(search_desc.videos).to eq [video_a, video_b]
      end

      it "returns videos sorted by view_count" do
        video_a = create(:video, view_count: 1)
        video_b = create(:video, view_count: 2)
        search_asc =
          described_class.new(
            sorting_params: {
              sort: "videos.view_count",
              direction: "ASC"
            }
          )
        search_desc =
          described_class.new(
            sorting_params: {
              sort: "videos.view_count",
              direction: "DESC"
            }
          )
        expect(search_asc.videos).to eq [video_b, video_a]
        expect(search_desc.videos).to eq [video_b, video_a]
      end

      it "returns videos sorted by popularity" do
        video_a = create(:video, popularity: 1)
        video_b = create(:video, popularity: 2)
        search_asc =
          described_class.new(
            sorting_params: {
              sort: "videos.popularity",
              direction: "ASC"
            }
          )
        search_desc =
          described_class.new(
            sorting_params: {
              sort: "videos.popularity",
              direction: "DESC"
            }
          )
        expect(search_asc.videos).to eq [video_b, video_a]
        expect(search_desc.videos).to eq [video_b, video_a]
      end

      it "returns videos sorted by updated_at" do
        video_a = create(:video)
        video_b = create(:video)
        search_asc =
          described_class.new(
            sorting_params: {
              sort: "videos.updated_at",
              direction: "ASC"
            }
          )
        search_desc =
          described_class.new(
            sorting_params: {
              sort: "videos.updated_at",
              direction: "DESC"
            }
          )
        expect(search_asc.videos).to eq [video_b, video_a]
        expect(search_desc.videos).to eq [video_b, video_a]
      end

      it "does not sort by parameter that's not a searchable column" do
        video_a = create(:video, title: "A")
        video_b = create(:video, title: "B")
        search_asc =
          described_class.new(
            sorting_params: {
              sort: "videos.title",
              direction: "ASC"
            }
          )
        search_desc =
          described_class.new(
            sorting_params: {
              sort: "videos.title",
              direction: "DESC"
            }
          )
        expect(search_asc.videos).to eq [video_a, video_b]
        expect(search_desc.videos).to eq [video_a, video_b]
      end
    end

    describe "filter_videos" do
      it "filters by leader" do
        leader = create(:leader)
        video_a = create(:video, leader: leader)
        video_b = create(:video)
        search = described_class.new(filtering_params: { leader: leader.full_name})
        expect(search.videos).to eq [video_a]
      end

      it "filters by follower" do
        follower = create(:follower)
        video_a = create(:video, follower: follower)
        video_b = create(:video)

        search =
          described_class.new(filtering_params: { follower: follower.full_name })

        expect(search.videos).to eq [video_a]
      end

      it "filters by channel_id" do
        channel = create(:channel)
        video_a = create(:video, channel: channel)
        video_b = create(:video)

        search =
          described_class.new(filtering_params: { channel_id: channel.id })

        expect(search.videos).to eq [video_a]
      end

      it "filters by genre" do
        song = create(:song, genre: "Tango")
        video_a = create(:video, song: song)
        video_b = create(:video)

        search = described_class.new(filtering_params: { genre: "Tango" })

        expect(search.videos).to eq [video_a]
      end

      it "filters by orchestra" do
        song = create(:song, artist: "Di Sarli")
        video_a = create(:video, song: song)
        video_b = create(:video)

        search =
          described_class.new(filtering_params: { orchestra: "Di Sarli" })

        expect(search.videos).to eq [video_a]
      end

      it "filters by song_id" do
        song = create(:song)
        video_a = create(:video, song: song)
        video_b = create(:video)

        search = described_class.new(filtering_params: { song_id: song.id })

        expect(search.videos).to eq [video_a]
      end

      it "filters by hd" do
        video_a = create(:video, hd: true)
        video_b = create(:video, hd: false)

        search_a = described_class.new(filtering_params: { hd: 1 })

        search_b = described_class.new(filtering_params: { hd: 0 })

        expect(search_a.videos).to eq [video_a]
        expect(search_b.videos).to eq [video_b]
      end

      it "filters by event_id" do
        event = create(:event)
        video_a = create(:video, event: event)
        video_b = create(:video)

        search = described_class.new(filtering_params: { event_id: event.id })

        expect(search.videos).to eq [video_a]
      end

      it "filters by year" do
        video_a = create(:video, upload_date: Time.zone.local(2018, 1, 1))
        video_b = create(:video)

        search = described_class.new(filtering_params: { year: "2018" })

        expect(search.videos).to eq [video_a]
      end

      describe "filter_by_query" do
        it "returns video with title that matches query" do
          video = create(:video, title: "Title with carlitos espinoza")
          search_a = described_class.new(filtering_params: { query: "Carlitos Espinoza" })
          search_b = described_class.new(filtering_params: { query: "John Doe" })
          search_c = described_class.new(filtering_params: { query: "Carlitos Espin" })
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with description that matches query" do
          video = create(:video, description: "description with carlitos espinoza")
          search_a = described_class.new(filtering_params: { query: "Carlitos Espinoza" })
          search_b = described_class.new(filtering_params: { query: "John Doe" })
          search_c = described_class.new(filtering_params: { query: "Carlitos Espin" })
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with leader name that matches query" do
          leader = create(:leader, name: "Carlitos Espinoza")
          video = create(:video, leader: leader)
          search_a = described_class.new(filtering_params: { query: "Carlitos Espinoza" })
          search_b = described_class.new(filtering_params: { query: "John Doe" })
          search_c = described_class.new(filtering_params: { query: "Carlitos Espin" })
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with follower name that matches query" do
          follower = create(:follower, name: "Noelia Hurtado")
          video = create(:video, follower: follower)
          search_a = described_class.new(filtering_params: { query: "Noelia Hurtado" })
          search_b = described_class.new(filtering_params: { query: "John Doe" })
          search_c = described_class.new(filtering_params: { query: "noeli" })
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with youtube_id that matches query" do
          video = create(:video, youtube_id: "s6iptZdCcG0")
          search_a = described_class.new(filtering_params: { query: "s6iptZdCcG0" })
          search_b = described_class.new(filtering_params: { query: "John Doe" })
          search_c = described_class.new(filtering_params: { query: "s6iptZdCcG" })
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with youtube_artist that matches query" do
          video = create(:video, youtube_artist: "Angel D'Agostino")
          search_a = described_class.new(filtering_params: { query: "Agostino" })
          search_b = described_class.new(filtering_params: { query: "John Doe" })
          search_c = described_class.new(filtering_params: { query: "Agostin" })
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with youtube_song that matches query" do
          video = create(:video, youtube_song: "No Vendrá")
          search_a = described_class.new(filtering_params: { query: "no vendrá" })
          search_b = described_class.new(filtering_params: { query: "John Doe" })
          search_c = described_class.new(filtering_params: { query: "no vend" })
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with spotify_track_name that matches query" do
          video = create(:video, spotify_track_name: "No Vendrá")
          search_a = described_class.new(filtering_params: { query: "no vendrá" })
          search_b = described_class.new(filtering_params: { query: "John Doe" })
          search_c = described_class.new(filtering_params: { query: "no vend" })
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with spotify_artist_name that matches query" do
          video = create(:video, spotify_artist_name: "Angel D'Agostino")
          search_a = described_class.new(filtering_params: { query: "agostino" })
          search_b = described_class.new(filtering_params: { query: "John Doe" })
          search_c = described_class.new(filtering_params: { query: "Angel D'Agosti" })
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with channel title that matches query" do
          channel = create(:channel, title: "030 Tango")
          video = create(:video, channel: channel)
          search_a = described_class.new(filtering_params: { query: "030 tango" })
          search_b = described_class.new(filtering_params: { query: "John Doe" })
          search_c = described_class.new(filtering_params: { query: "030 T" })
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with song genre that matches query" do
          song = create(:song, genre: "Tango")
          video = create(:video, song: song)
          search_a = described_class.new(filtering_params: { query: "tango" })
          search_b =
            described_class.new(filtering_params: { query: "John Doe" })
          search_c = described_class.new(filtering_params: { query: "tang" })
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with song title that matches query" do
          song = create(:song, title: "La Mentirosa")
          video = create(:video, song: song)
          search_a = described_class.new(filtering_params: { query: "mentirosa" })
          search_b = described_class.new(filtering_params: { query: "John Doe" })
          search_c = described_class.new(filtering_params: { query: "menti" })
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with song artist that matches query" do
          song = create(:song, artist: "Angel D'Agostino")
          video = create(:video, song: song)
          search_a = described_class.new(filtering_params: { query: "d'agostino" })
          search_b = described_class.new(filtering_params: { query: "John Doe" })
          search_c = described_class.new(filtering_params: { query: "Agosti" })
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end
      end
    end
  end

  describe "#paginated_videos" do
    it "paginates videos" do
      stub_const("Video::Search::NUMBER_OF_VIDEOS_PER_PAGE", 2)
      create_list(:video, 3)
      page1 = described_class.new(page: 1)
      page2 = described_class.new(page: 2)
      page3 = described_class.new(page: 3)
      expect(page1.paginated_videos.count).to eq(2)
      expect(page2.paginated_videos.count).to eq(1)
      expect(page3.paginated_videos.count).to eq(0)
    end

    it "shuffles videos if sorting/filtering params empty" do
      srand(3)
      video1 = create(:video, hd: 1)
      video2 = create(:video, hd: 1)
      video3 = create(:video, hd: 1)
      page_shuffled = described_class.new(page: 1)
      page_not_shuffled =
        described_class.new(page: 1, filtering_params: { hd: 1 })
      expect(page_shuffled.paginated_videos).to eq([video2, video1, video3])
      expect(page_not_shuffled.paginated_videos).to eq([video1, video2, video3])
    end
  end

  describe "#displayed_videos_count" do
    it "counts the total amount of displayed videos" do
      stub_const("Video::Search::NUMBER_OF_VIDEOS_PER_PAGE", 2)
      create_list(:video, 3)
      page1 = described_class.new(page: 1)
      page2 = described_class.new(page: 2)
      page3 = described_class.new(page: 3)
      expect(page1.displayed_videos_count).to eq(2)
      expect(page2.displayed_videos_count).to eq(3)
      expect(page3.displayed_videos_count).to eq(4)
    end
  end

  describe "#next_page?" do
    it "returns the next page" do
      stub_const("Video::Search::NUMBER_OF_VIDEOS_PER_PAGE", 2)
      create_list(:video, 3)
      page1 = described_class.new(page: 1)
      page2 = described_class.new(page: 2)
      expect(page1.next_page?).to eq(true)
      expect(page2.next_page?).to eq(false)
    end
  end

  describe "#leaders" do
    it "creates array of leaders and increments multiple videos without duplication" do
      leader = create(:leader, name: "Carlitos Espinoza")
      leader2 = create(:leader, name: "Sebastian Jimenez")
      create(:video, leader: leader)
      create(:video, leader: leader2)
      create(:video, leader: leader2)

      search = described_class.new
      expect(search.leaders).to eq(
        [
          ["Sebastian Jimenez (2)", "sebastian jimenez"],
          ["Carlitos Espinoza (1)", "carlitos espinoza"]
        ]
      )
    end
  end

  describe "#followers" do
    it "creates array of followers and increments multiple videos without duplication" do
      follower = create(:follower, name: "Noelia Hurtado")
      follower2 = create(:follower, name: "Moira Castellano")
      create(:video, follower: follower)
      create(:video, follower: follower2)
      create(:video, follower: follower2)

      search = described_class.new
      expect(search.followers).to eq(
        [
          ["Moira Castellano (2)", "moira castellano"],
          ["Noelia Hurtado (1)", "noelia hurtado"]
        ]
      )
    end
  end

  describe "#orchestras" do
    it "creates array of ors and increments multiple videos without duplication" do
      song = create(:song, artist: "Carlos Di Sarli")
      song2 = create(:song, artist: "Osvaldo Pugliese")
      create(:video, song: song)
      create(:video, song: song2)
      create(:video, song: song2)

      search = described_class.new
      expect(search.orchestras).to eq(
        [
          ["Osvaldo Pugliese (2)", "osvaldo pugliese"],
          ["Carlos Di Sarli (1)", "carlos di sarli"]
        ]
      )
    end
  end

  describe "#genre" do
    it "creates array of songs and increments multiple videos without duplication" do
      song = create(:song, genre: "Milonga")
      song2 = create(:song, genre: "Tango")
      create(:video, song: song)
      create(:video, song: song2)
      create(:video, song: song2)

      search = described_class.new
      expect(search.genres).to eq(
        [["Tango (2)", "tango"], ["Milonga (1)", "milonga"]]
      )
    end
  end

  describe "#years" do
    it "creates array of songs and increments multiple videos without duplication" do
      create(:video, upload_date: Time.zone.local(2018, 1, 1))
      create(:video, upload_date: Time.zone.local(2018, 1, 1))
      create(:video, upload_date: Time.zone.local(2017, 1, 1))

      search = described_class.new
      expect(search.years).to eq([["2018 (2)", 2018], ["2017 (1)", 2017]])
    end
  end
end
