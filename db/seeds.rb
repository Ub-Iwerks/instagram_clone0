User.create!(name: "Example user", username: "Example", email: "example@railstutorial.org", password: "foobar", password_confirmation: "foobar")
99.times do |n|
  name = Faker::Name.name
  username = Faker::Internet.user_name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name, email: email, username: username, password: password, password_confirmation: password)
end

#ユーザーの一部を対象にポストを生成する。
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.posts.create!(content: content) }
end

users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

