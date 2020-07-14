FactoryBot.define do
  factory :post do
    content { 'spec content' }
    association :user
  end
end
