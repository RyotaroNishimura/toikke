# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


User.create!(name:  "山田 太郎",
             email: "example@example.com",
             password:              "example",
             password_confirmation: "example",
             admin: true)

99.times do |n|
 name  = Faker::Name.name
 email = "example-#{n+1}@example.com"
 password = "password"
 User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password)
end

10.times do |n|
  Post.create!(
               user_id: 1,
               title: "七つの習慣",
               category: "政治",
               price: 1500,
               popularity: 5,
               content: "初めて本を紹介した",
              )
end

users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

