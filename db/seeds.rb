
User.create!(name: "Example User",
  email: "huy25107@gmail.com",
  admin: true,
  password: "123123",
  password_confirmation: "123123")

# Generate a bunch of additional users.
30.times do |n|
name = Faker::Name.name
email = "example-#{n + 1}@railstutorial.org"
password = "123123"
User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password)
end

#Generate microposts
users = User.order(:created_at).take(6)
50.times do
content = Faker::Lorem.sentence(word_count: 10)
users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
users = User.all
user = users.first
following = users[2..20]
followers = users[3..15]
following.each{|followed| user.follow(followed)}
followers.each{|follower| follower.follow(user)}