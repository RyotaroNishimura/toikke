FactoryBot.define do
  factory :user, aliases: [:follower, :followed] do
    name { Faker::Name.name }
    sex { 1 }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }

    trait :admin do
      admin { true }
    end
  end
end
