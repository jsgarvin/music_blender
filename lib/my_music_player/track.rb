module MyMusicPlayer
  class Track < ActiveRecord::Base
    validates_uniqueness_of :relative_path, :scope => :root_folder_id
    before_save :import_id3_tag_attributes

    belongs_to :root_folder

    def full_path
      "#{root_folder.path}/#{relative_path}"
    end

    #######
    private
    #######

    def import_id3_tag_attributes
      self.title ||= id3_tag.title
    end

    def id3_tag
      @id3_tag ||= TagLib::MPEG::File.new(full_path).id3v2_tag(true)
    end

  end
end
