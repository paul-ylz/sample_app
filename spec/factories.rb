FactoryGirl.define do
  # Sequences
  sequence(:name) { Faker::Name.name }
  sequence(:email) { Faker::Internet.email }
  sequence(:username) do |n|
    Faker::Internet.user_name(4..12) + n.to_s
  end

  # Factories
  factory :user do
    name
    email
    username
    password "password"
    password_confirmation "password"
    active true
    # Chap 9.41 nesting attributes in factories
    factory :admin do
      admin true
    end
    factory :unconfirmed_user do
      active false
    end
  end

  factory :micropost do
    content "Make that... *four* months detention."
    user
  end

  factory :message do
    from 1
    to 2
    content "Just because I don't care doesn't mean I don't understand."
  end
end
