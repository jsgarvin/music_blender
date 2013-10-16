FactoryGirl.define do

  factory :music_folder, :class => MyMusicPlayer::MusicFolder do
    path '/some/music/path/'

    factory :music_folder_with_tracks do
      after(:build) do |music_folder|
        3.times { music_folder.tracks << build(:track) }
      end
    end

  end

end

