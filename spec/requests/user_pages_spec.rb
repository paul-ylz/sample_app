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
				it { should have_link('Sign out') }
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

	describe "edit" do 
		let(:user) { create(:user) }
		before do 
			sign_in user 
			visit edit_user_path(user)
		end

		describe "page" do 
			it { should have_content('Update your profile') }
			it { should have_title('Edit user') }
			it { should have_link('change', href: 'http://gravatar.com/emails') }
		end

		describe "with invalid information" do 
			before { click_button "Save changes" }

			it { should have_content('error') }
		end

		describe "with valid information" do 
			let(:new_name) { "New Name" }
			let(:new_email) { "new@email.add" }
			before do 
				fill_in "Name", with: new_name
				fill_in "Email", with: new_email
				fill_in "Password", with: 'newpassword'
				fill_in "Confirm Password", with: 'newpassword'
				click_button 'Save changes'
			end

			it { should have_title(new_name) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign out', href: signout_path) }
			specify { expect(user.reload.name).to eq new_name }
			specify { expect(user.reload.email).to eq new_email }
		end
	end

end
