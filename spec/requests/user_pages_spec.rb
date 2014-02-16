require 'spec_helper'

describe "UserPages" do

	subject { page }

	describe "signup" do 
		let(:submit) { "Create my account" }
		before { visit signup_path }
		# Ex 5.6.1 Using Capybara's have_selector
		# replace:
		# it { should have_content('Sign up') }
		# with more precise:
		# it { should have_selector('h1', text: 'Sign up') }
		it { should have_selector('h1', text: 'Sign up') }
		specify { page_has_title(full_title('Sign up')) }
		describe "with invalid information" do 
			it "should not sign up a user" do 
				expect { click_button submit }.not_to change(User, :count)
			end
			# Ex 7.6.2 Test error messages for user sign-up.
			describe "displays error messages" do 
				before { click_button submit }
				specify { page_has_title('Sign up') }
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
				specify { page_has_title(user.name) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }
				it { should have_link('Sign out') }
			end
		end
	end

	let(:user) { create(:user) }

	describe "profile" do 
		# Chap 7.8, using FactoryGirl's syntax to create a user from the definition
		# in /spec/factories.rb
		before { visit user_path(user) }
		specify { page_has_title_and_h1(user.name) }
	end

	describe "edit" do 
		before do 
			sign_in user 
			visit edit_user_path(user)
		end
		it { should have_content('Update your profile') }
		specify { page_has_title_and_h1('Edit user') }
		it { should have_link('change', href: 'http://gravatar.com/emails') }

		describe "with invalid information" do 
			before { click_button "Save changes" }
			it { should have_error_message }
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
			specify { page_has_title(new_name) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign out', href: signout_path) }
			specify { expect(user.reload.name).to eq new_name }
			specify { expect(user.reload.email).to eq new_email }
		end
	end

	describe "index" do 
		before do 
			sign_in user
			visit users_path
		end
		specify { page_has_title_and_h1('All users') }

		describe "pagination" do 
			# Chap 9.31 before(:all) and after(:all) ensure these functions are carried
			# out only once for all tests in the block (an optimization for speed).
			before(:all) { 30.times { create(:user) } }
			after(:all) { User.delete_all }

			# test that the will_paginate gem is in force
			it { should have_selector('div.pagination') }

			it "should list each user" do 
				User.paginate(page: 1).each do |u|
					expect(page).to have_selector('li', text: u.name)
				end
			end
		end
		
	end
end
