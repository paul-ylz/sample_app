namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    make_admin
    make_users
    make_microposts
    make_relationships
  end
end

def make_admin
  User.create!(
    name:                   'Foo Bar',
    email:                  'foo@bar.com',
    username:               'foo_bar',
    password:               'password',
    password_confirmation:  'password',
    active: true,
    # Make the first user admin by default
    admin: true
    )
end

def make_users
  99.times do |n|
      name     = Faker::Name.name
      email    = Faker::Internet.email
      username = Faker::Internet.user_name(4..12) + n.to_s
      password = 'password'
      User.create!(
        name: name,
        email: email,
        username: username,
        password: password,
        password_confirmation: password,
        active: true
        )
    end
end

def make_microposts
  users = User.limit(6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users          = User.all
  user           = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |u| user.follow!(u) }
  followers.each { |u| u.follow!(user) }
end
