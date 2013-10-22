module MyMusicPlayer
  class Track < ActiveRecord::Base

    validates_uniqueness_of :relative_path, :scope => :music_folder_id
    validates_numericality_of :rating, :greater_than => 0, :only_integer => true

    before_validation :import_id3_tag_attributes, :on => :create

    before_save :persist_rating_to_id3_tag, :on => :update, :if => :rating_changed?

    belongs_to :artist
    belongs_to :music_folder

    scope :by_weighted_random, ->() {
      select(%Q{*, ((strftime('%s','now') - strftime('%s', ifnull(last_played_at,created_at)))/#{1.month.seconds.to_f})*rating*random() AS weighted_random}).order('weighted_random')
    }

    scope :except_recently_played, ->() {
      where(['last_played_at IS NULL OR last_played_at < ?', Track.unscoped.most_recent((count*0.1)+1).last.last_played_at])
    }

    scope :except_by_recently_played_artists, ->() {
      where(['artist_id NOT IN (?)',Track.unscoped.most_recent((count*0.02)+1).select(:artist_id).map(&:artist_id)])
    }

    scope :most_recent, ->(number) { order('last_played_at DESC').limit(number) }

    def full_path
      "#{music_folder.path}/#{relative_path}"
    end

    def import_id3_tag_attributes!
      import_id3_tag_attributes
      save
    end

    #######
    private
    #######

    def import_id3_tag_attributes
      self.title = id3_title
      self.artist = Artist.find_or_create_by(:name => id3_artist)
      self.rating = id3_rating
    end

    def id3_title
      id3_adapter.title
    end

    def id3_artist
      id3_adapter.artist
    end

    def id3_rating
      id3_adapter.rating
    end

    def persist_rating_to_id3_tag
      id3_adapter.set_rating(rating.to_s)
    end

    def id3_adapter
      @id3_adapter ||= Id3Adapter.new(full_path,rating)
    end
  end
end
