module MyMusicPlayer
  class Track < ActiveRecord::Base
    RATING_FRAME_DESCRIPTION = 'MMP Rating'

    validates_uniqueness_of :relative_path, :scope => :music_folder_id
    validates_numericality_of :rating, :greater_than => 0, :only_integer => true

    before_validation :import_id3_tag_attributes

    after_update :persist_rating_to_id3_tag, :if => :rating_changed?

    belongs_to :music_folder

    def full_path
      "#{music_folder.path}/#{relative_path}"
    end

    #######
    private
    #######

    def resolve_rating_conflict
      if rating_frame.text.blank?
        persist_rating_to_id3_tag
      else
        self.update_atribute(:rating,rating_frame.text.to_i)
      end
    end

    def import_id3_tag_attributes
      self.title ||= id3_tag.title
      self.rating = rating_frame.text
    end

    def id3_tag
      @id3_tag ||= id3_tag_file.id3v2_tag(true)
    end

    def id3_tag_file
      @id3_tag_file ||= TagLib::MPEG::File.new(full_path)
    end

    def rating_frame
      find_rating_frame || create_rating_frame
    end

    def find_rating_frame
      id3_tag.frame_list.detect { |frame|
        frame.is_a?(TagLib::ID3v2::CommentsFrame) and
          frame.description == RATING_FRAME_DESCRIPTION
      }
    end

    def create_rating_frame
      TagLib::ID3v2::CommentsFrame.new.tap do |rating_frame|
        rating_frame.description = RATING_FRAME_DESCRIPTION
        rating_frame.text = (rating || 1).to_s
        id3_tag.add_frame(rating_frame)
        id3_tag_file.save
      end
    end

    def persist_rating_to_id3_tag
      rating_frame.text = rating.to_s
      id3_tag_file.save
    end
  end
end
