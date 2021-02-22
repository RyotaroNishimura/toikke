FactoryBot.define do
  factory :comment do
    user_id { 1 }
    content { "シェアしてくださりありがとうございます" }
    association :post
  end
end
