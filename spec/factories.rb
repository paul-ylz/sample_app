FactoryGirl.define do 
	factory :user do 
		# Chap 9.31 Using sequences to create multiple users.
		sequence(:name) { Faker::Name.name }
		sequence(:email) { Faker::Internet.email }
		password "password"
		password_confirmation "password"

		# Chap 9.41 nesting attributes in factories
		factory :admin do 
			admin true
		end
	end
end