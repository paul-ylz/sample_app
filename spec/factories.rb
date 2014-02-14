FactoryGirl.define do 
	factory :user do 
		name	"Foo Bar"
		email	"foo@bar.com"
		password "password"
		password_confirmation "password"
	end
end