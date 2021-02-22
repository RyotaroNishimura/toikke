FactoryBot.define do
  factory :post do
    association :user
    title { "浜田山" }
    adress { "東京都杉並区浜田山3丁目" }
    popularity { 5 }
    freeornot { 1 }
    unnko { 3 }
    syoben { 5 }
    content { 'トイレットペーパーが切れてた' }
  end

  trait :yesterday do
    created_at { 1.day.ago }
  end

  trait :one_week_ago do
    created_at { 1.week.ago }
  end

  trait :one_month_ago do
    created_at { 1.month.ago }
  end
end
