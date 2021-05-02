class Video::MusicRecognition::AcrCloud::Audio
  class << self
    def import(youtube_id)
      new(youtube_id).import
    end
  end

  def initialize(youtube_id)
    @youtube_id = youtube_id
    @youtube_video_audio_file = fetch_by_id(youtube_id)
  end

  def import
    transcode_audio_file
  end

  private

  def fetch_by_id(_youtube_id)
    YoutubeDL.download(
      "https://www.youtube.com/watch?v=#{@youtube_id}",
      { format: "140", output: "~/environment/data/audio/%(id)s.mp3" }
    )
  end

  def youtube_audio_file_path
    @youtube_video_audio_file.filename.to_s
  end

  def output_file_path
    @output_file_path ||=
      youtube_audio_file_path.gsub(
        /.mp3/,
        "_#{sample_start_time}_#{sample_end_time}.mp3"
      )
  end

  def sample_start_time
    @sample_start_time ||= @youtube_video_audio_file.duration / 2
  end

  def sample_end_time
    @sample_end_time ||= sample_start_time + 20
  end

  def transcode_audio_file
    song = FFMPEG::Movie.new(youtube_audio_file_path)
    song.transcode(
      output_file_path,
      { custom: %W[-ss #{sample_start_time} -to #{sample_end_time}] }
    )
    output_file_path
  end
end
