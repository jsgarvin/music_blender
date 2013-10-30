FactoryGirl.define do

  factory :music_folder, :class => MusicBlender::MusicFolder do
    path '/some/music/path/'

    factory :music_folder_with_tracks do
      after(:create) do |music_folder|
        3.times { music_folder.tracks << create(:track) }
      end
    end

  end

end

