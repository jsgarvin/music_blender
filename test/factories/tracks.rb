FactoryGirl.define do

  factory :track, :class => MyMusicPlayer::Track do
    association :artist
    association :music_folder
    sequence(:relative_path) { |counter| "/some/path/#{counter}.mp3" }
    sequence(:title) { |counter| "Factory Generated #{counter}" }
    sequence(:last_played_at) { |counter| counter.hours.ago }
    rating 5
  end

end
