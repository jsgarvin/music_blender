FactoryGirl.define do

  factory :artist, :class => MusicBlender::Artist do
    sequence(:name) { |counter| "Factory Generated #{counter}" }
  end

end
