FactoryGirl.define do 
	factory :user do 
		# Chap 9.31 Using sequences to create multiple users.
		sequence(:name) { Faker::Name.name }
		sequence(:email) { Faker::Internet.email }
		password "password"
		password_confirmation "password"
	end
end