FactoryGirl.define do

  factory :track, :class => MyMusicPlayer::Track do
    association :root_folder
    sequence(:relative_path) { |counter| "/some/path/#{counter}.mp3" }
  end

end
