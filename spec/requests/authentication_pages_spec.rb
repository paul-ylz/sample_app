require 'spec_helper'

describe "Authentication" do

	subject { page }

	describe "signin page" do 
		before { visit signin_path }

		it { should have_title('Sign in') }

		describe "sign in with invalid information" do 
		before { click_button "Sign in" }

		it { should have_title('Sign in') }		
		it { should have_error_message('Invalid') }
			
			# Test for persistence of flash error message. The issue is that flash 
			# messages persist for 1 request. However, we render 'new' with invalid 
			# login, which unlike 'redirect_to', does not count as a request.
			describe "after visiting another page" do
				before { click_link "Home" }

				it { should_not have_error_message }
			end
		end

		describe "sign in with valid information" do 
			let(:user) { create(:user) }
			before { sign_in(user) }

			it { should have_signed_in_attributes(user) }
			it { should_not have_link('Sign in', href: signin_path) }

			describe "followed by signout" do 
				before { click_link "Sign out" }
				
				it { should have_link('Sign in') }
			end
		end
	end

	describe "authorization" do 

		describe "for non signed in users" do 
			let(:user) { create(:user) }

			describe "in the users controller" do 

				describe "visiting the edit page" do 
					before { visit edit_user_path(user) }

					it { should have_title('Sign in') }
				end

				describe "submitting to the update action" do 
					before { patch user_path(user) }

					specify { expect(response).to redirect_to(signin_path) }
				end
			end
		end

		describe "for wrong users" do 
			let(:ned) { create(:user) }
			let(:homer) { create(:user, email: "naughty@user.com") }
			# Chap 9.2.2 We cannot use capybara for these tests because a user would
			# not be able to access these routes via browser links. 
			before { sign_in homer, no_capybara: true }

			describe "submit GET to User#edit" do 
				before { get edit_user_path(ned) }
				specify { expect(response.body).not_to match(full_title('Edit User')) }
				specify { expect(response).to redirect_to(root_url) }
			end

			describe "submit PATCH to Users#update" do 
				before { patch user_path(ned) }
				specify { expect(response).to redirect_to(root_url) }
			end
		end 

	end
end

