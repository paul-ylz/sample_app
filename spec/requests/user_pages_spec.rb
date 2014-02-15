require 'spec_helper'

describe "UserPages" do

	subject { page }

	describe "signup page" do 
		let(:submit) { "Create my account" }
		before { visit signup_path }

		# Ex 5.6.1 Using Capybara's have_selector
		# replace:
		# it { should have_content('Sign up') }
		# with more precise:
		# it { should have_selector('h1', text: 'Sign up') }

		it { should have_selector('h1', text: 'Sign up') }
		it { should have_title(full_title('Sign up')) }

		describe "with invalid information" do 

			it "should not sign up a user" do 
				expect { click_button submit }.not_to change(User, :count)
			end

			# Ex 7.6.2 Test error messages for user sign-up.
			describe "displays error messages" do 
				before { click_button submit }

				it { should have_title('Sign up') }
				it { should have_selector('div#error_explanation', text: 'error') }
			end
		end
		
		describe "with valid information" do 

			let(:fill_user_details) do 
				fill_in "Name", with: "Foo Bar"
				fill_in "Email", with: "foo@bar.com"
				fill_in "Password", with: "password"
				fill_in "Confirmation", with: "password"
				click_button submit
			end

			it "should sign up a new user" do 				
				expect { fill_user_details }.to change(User, :count).by(1)
			end

			# Ex 7.6.3 Test post user creation.
			describe "after saving the user" do 
				before { fill_user_details }
				let(:user) { User.find_by(email: 'foo@bar.com') }

				it { should have_title(user.name) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }
			end
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
