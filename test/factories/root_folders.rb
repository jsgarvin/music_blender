FactoryGirl.define do

  factory :root_folder, :class => MyMusicPlayer::RootFolder do
    path '/some/root/path/'

    factory :root_folder_with_tracks do
      after(:build) do |root_folder|
        3.times { root_folder.tracks << build(:track) }
      end
    end

  end

end

