require "rails_helper"

RSpec.describe Channel, type: :model do
  it_behaves_like "an importable", :channel
  it_behaves_like "a reviewable", :channel

  describe "validations" do
    it { is_expected.to validate_uniqueness_of(:channel_id) }
  end

  describe "associations" do
    it { is_expected.to have_many(:videos) }
  end

  describe "#update_imported" do
    it "doesn't update if the count is not changing" do
      channel = create(:channel, total_videos_count: 500, videos_count: 499)
      expect { channel.update(title: "blah blah") }.not_to change(
        channel.reload,
        :imported
      )
    end

    it "updates the imported status if count is equal" do
      channel = create(:channel, total_videos_count: 500, videos_count: 499)
      expect { channel.update(videos_count: 500) }.to change(
        channel.reload,
        :imported
      )
    end

    it "doesn't update if the videos count is less than total_vides_count" do
      channel = create(:channel, total_videos_count: 500, videos_count: 499)
      expect { channel.update(videos_count: 501) }.to change {
        channel.reload.imported
      }.from(false).to(true)
    end
  end

  describe "scope" do
    describe "title_search" do
      it "returns channels that match title with exact match, without caps, without accents and with partial match" do
        matching_channel = create(:channel, title: "ChánneL Títle")
        no_match_channel = create(:channel)
        expect(described_class.title_search("ChánneL Títle")).to include(
          matching_channel
        )
        expect(described_class.title_search("ChánneL Títle")).not_to include(
          no_match_channel
        )
        expect(described_class.title_search("chánnel títle")).to include(
          matching_channel
        )
        expect(described_class.title_search("chánnel títle")).not_to include(
          no_match_channel
        )
        expect(described_class.title_search("channel title")).to include(
          matching_channel
        )
        expect(described_class.title_search("channel title")).not_to include(
          no_match_channel
        )
        expect(described_class.title_search("chann")).to include(
          matching_channel
        )
        expect(described_class.title_search("chann")).not_to include(
          no_match_channel
        )
      end
    end
  end
end
