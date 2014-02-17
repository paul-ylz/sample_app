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

	# Chap 10.1.4 The following allows microposts creation with syntax such as
	# create(:micropost, user: @user, created_at: 1.day.ago)
	factory :micropost do 
		content "Make that... *four* months detention."
		user
	end
end