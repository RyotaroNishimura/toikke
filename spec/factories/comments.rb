FactoryBot.define do
  factory :comment do
    user_id { 1 }
    content { "めっちゃ面白いじゃん" }
    association :post
  end
end
