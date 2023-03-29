# spec/factories/questions.rb
FactoryBot.define do
  factory :question do
    text { Faker::Games::LeagueOfLegends.quote }
  end
end
