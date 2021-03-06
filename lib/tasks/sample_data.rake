namespace :db do
    desc "Fill database with sample data"
    task populate: :environment do
        make_users
        make_microposts
        make_microposts_with_reply
        make_relationships
    end
end

def make_users
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 username: "example",
                 admin: true)
    User.create!(name: "Admin User",
                 email: "admin@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 username: "admin",
                 admin: true)
    99.times do |n|
        name = Faker::Name.name
        email = "example-#{n+1}@railstutorial.org"
        password = "password"
        username = "example#{n+1}"
        User.create!(name: name,
                     email: email,
                     password: password,
                     password_confirmation: password,
                     username: username)
    end
end

def make_microposts
    users = User.all(limit: 6)
    50.times do
        content = Faker::Lorem.sentence(5)
        users.each { |user| user.microposts.create!(content: content) }
    end
end

def make_microposts_with_reply
    users = User.all(limit: 6)
    users.each do |user_mentioning| 
        users.each do |user_mentioned|
            content = "@" + user_mentioned.username + " " + Faker::Lorem.sentence(4)
            user_mentioning.microposts.create!(content: content) unless user_mentioning == user_mentioned
        end
    end
end

def make_relationships
    users = User.all
    user = users.first
    followed_users = users[2..50]
    followers = users[3..40]
    followed_users.each { |followed| user.follow!(followed) }
    followers.each { |follower| follower.follow!(user) }
end
