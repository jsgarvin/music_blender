module MyMusicPlayer
  class Id3Adapter
    RATING_FRAME_DESCRIPTION = 'MMP Rating'
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def title
      v2tag.title || v1tag.title
    end

    def artist
      v2tag.artist || v1tag.artist
    end

    def rating
      rating_frame.text.to_i
    end

    def set_rating(value)
      rating_frame.text = value.to_s
      tag_file.save
    end

    #######
    private
    #######

    def v1tag
      @v1tag ||= tag_file.id3v1_tag(true)
    end

    def v2tag
      @v2tag ||= tag_file.id3v2_tag(true)
    end

    def tag_file
      @tag_file ||= TagLib::MPEG::File.new(path)
    end

    def rating_frame
      @rating_frame ||= (find_rating_frame || create_and_find_rating_frame)
    end

    def find_rating_frame
      v2tag.frame_list.detect { |frame|
        frame.is_a?(TagLib::ID3v2::CommentsFrame) and
          frame.description == RATING_FRAME_DESCRIPTION
      }
    end

    def create_and_find_rating_frame
      TagLib::ID3v2::CommentsFrame.new.tap do |rating_frame|
        rating_frame.description = RATING_FRAME_DESCRIPTION
        rating_frame.text = (rating || 1).to_s
        v2tag.add_frame(rating_frame)
        tag_file.save
      end
      # Due to quirk in TagLib, the rating_frame
      # from the above block is not accessible
      # anymore, so need to re-find an instance
      # of it that we can read and manipulate.
      find_rating_frame
    end

  end
end
