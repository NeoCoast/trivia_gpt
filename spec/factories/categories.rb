# spec/factories/categories.rb
FactoryBot.define do
  factory :category do
    name { Faker::Games::LeagueOfLegends.champion }
  end
end
