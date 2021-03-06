User.create! name: "Admin", email: "admin@example.com",
  password: "123123", password_confirmation: "123123", is_admin: true,
  activated: true, activated_at:Time.zone.now

20.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@example.com"
  password = "password"
  User.create! name: name, email: email, password: password,
    password_confirmation: password, activated: true, activated_at: Time.zone.now
end

users = User.order(:created_at).take Settings.micropost.number_of_users
50.times do
  content = Faker::Lorem.sentence Settings.micropost.lorem_sentences
  users.each {|user| user.microposts.create! content: content}
end

users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each{|followed| user.follow followed}
followers.each{|follower| follower.follow user}
