FactoryBot.define do
  factory :post do
    association :user
    title { "七つの週間" }
    category { "政治" }
    price { 1500 }
    popularity { 5 }
    content { 'この本は私が大学生の頃に読んだ本です' }
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
