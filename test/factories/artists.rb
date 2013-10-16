FactoryGirl.define do

  factory :artist, :class => MyMusicPlayer::Artist do
    sequence(:name) { |counter| "Factory Generated #{counter}" }
    #association :music_folder
    #sequence(:relative_path) { |counter| "/some/path/#{counter}.mp3" }
    #rating 5
  end

end
