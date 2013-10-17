FactoryGirl.define do

  factory :artist, :class => MyMusicPlayer::Artist do
    sequence(:name) { |counter| "Factory Generated #{counter}" }
  end

end
