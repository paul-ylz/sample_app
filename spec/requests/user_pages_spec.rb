require 'spec_helper'

describe "UserPages" do
	# Chap 7.8, using FactoryGirl's syntax to create a user from the definition
	# in /spec/factories.rb
	# 
	let(:user) { create(:user) }

	subject { page }

	describe "Sign up" do 
		let(:submit) { "Create my account" }
		before { visit signup_path }
		# Ex 5.6.1 Using Capybara's have_selector
		it { should have_selector('h1', text: 'Sign up') }
		it { should have_title(full_title('Sign up')) }

		describe "with invalid information" do 
			it "should not sign up a user" do 
				expect { click_button submit }.not_to change(User, :count)
			end
			# Ex 7.6.2 Test error messages for user sign-up.
			describe "should display errors" do 
				before { click_button submit }
				it { should have_title(full_title('Sign up')) }
				it { should have_selector('div#error_explanation', text: 'error') }
			end
		end

		describe "with valid information" do 
			let(:sign_up) do 
				fill_in "Name", with: "Foo Bar"
				fill_in "Email", with: "foo@bar.com"
				fill_in "Password", with: "password"
				fill_in "Confirm Password", with: "password"
				click_button submit
			end
			it "should sign up a new user" do 				
				expect { sign_up }.to change(User, :count).by(1)
			end
			# Ex 7.6.3 Test post user creation.
			describe "after creating the user" do 
				before { sign_up }
				it { should have_title('Foo Bar') }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }
				it { should have_link('Sign out') }
			end
		end
	end


	describe "Profile (show user) page" do 
		describe "for unauthenticated users" do 
			before { visit user_path user }
			it { should have_title(user.name) }
			it { should have_selector('h1', text: user.name) }
		end

		describe "follow/unfollow buttons" do 
			let(:other_user) { create(:user) }
			before { sign_in user }

			describe "following a user" do 
				before { visit user_path(other_user) }

				it "should increment the followed user count" do 
					expect do 
						click_button "Follow"
					end.to change(user.followed_users, :count).by(1)
				end

				it "should increment the other user's followers count" do 
					expect do 
						click_button "Follow"
					end.to change(other_user.followers, :count).by(1)
				end

				describe "toggling the button" do 
					before { click_button "Follow" }
					it { should have_xpath("//input[@value='Unfollow']") }
				end
			end

			describe "unfollowing a user" do 
				before do 
					user.follow!(other_user)
					visit user_path(other_user)
				end

				it "should decrement the followed user count" do 
					expect do 
						click_button "Unfollow"
					end.to change(other_user.followers, :count).by(-1)
				end

				it "should decrement the other user's followers count" do 
					expect do 
						click_button "Unfollow"
					end.to change(other_user.followers, :count).by(-1)
				end

				describe "toggling the button" do 
					before { click_button "Unfollow" }
					it { should have_xpath("//input[@value='Follow']") }
				end
			end
		end
	end


	describe "Settings (edit user) page" do 
		before do 
			sign_in user 
			visit edit_user_path(user)
		end
		it { should have_content('Update your profile') }
		it { should have_title('Edit user') }
		it { should have_link('change', href: 'http://gravatar.com/emails') }

		describe "updating with invalid information" do 
			before { click_button "Save changes" }
			it { should have_error_message }
		end

		describe "updating with valid information" do 
			let(:marge) { build(:user) }
			before do 
				fill_in "Name", with: marge.name
				fill_in "Email", with: marge.email
				fill_in "Password", with: marge.password
				fill_in "Confirm Password", with: marge.password
				click_button 'Save changes'
			end
			it { should have_title(marge.name) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign out', href: signout_path) }
			specify { expect(user.reload.name).to eq marge.name }
			specify { expect(user.reload.email).to eq marge.email }
		end
	end


	describe "Index page" do 
		before do 
			sign_in user
			visit users_path
		end
		it { should have_title('All users') }
		it { should have_selector('h1', 'All users') }

		describe "pagination of users" do 
			# Chap 9.31 before(:all) and after(:all) ensure these functions are carried
			# out only once for all tests in the block (an optimization for speed).
			# 
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

		it "should not have delete links for non administrators" do 
			expect(page).not_to have_link('delete')
		end
	end


	describe "Following and follower pages" do 
		let(:homer) { create(:user, name: 'Homer Simpson') }
		let(:marge) { create(:user, name: 'Marge Simpson') }
		before { marge.follow!(homer) }

		describe "followed users" do 
			before do 
				sign_in marge 
				visit following_user_path(marge)
			end
			it { should have_title(full_title('Following')) }
			it { should have_selector('h3', text: 'Following') }
			it { should have_link(homer.name, href: user_path(homer)) }
		end

		describe "followers" do 
			before do 
				sign_in homer 
				visit followers_user_path(homer)
			end
			it { should have_title(full_title('Followers')) }
			it { should have_selector('h3', text: 'Followers') }
			it { should have_link(marge.name, href: user_path(marge)) }
		end
	end
end