require 'spec_helper'

describe "UserPages" do

	subject { page }

	describe "signup page" do 
		let(:submit) { "Create my account" }
		before { visit signup_path }

		# Ex 5.6.1 Using Capybara's have_selector
		# replace:
		# it { should have_content('Sign up') }
		# with:
		it { should have_selector('h1', text: 'Sign up') }
		it { should have_title(full_title('Sign up')) }

		it "should not sign up a user with incomplete information" do 
			expect { click_button submit }.not_to change(User, :count)
		end

		it "should sign up a new user with valid information" do 
			fill_in "Name", with: "Foo Bar"
			fill_in "Email", with: "foo@bar.com"
			fill_in "Password", with: "password"
			fill_in "Confirmation", with: "password"
			expect { click_button submit }.to change(User, :count).by(1)
		end
	end

	describe "profile page" do 
		# Chap 7.8, using FactoryGirl's syntax to create a user from the definition
		# in /spec/factories.rb
		let(:user) { create(:user) }
		before { visit user_path(user) }

		it { should have_title(user.name) }
		it { should have_selector('h1', text: user.name) }
	end



end
