require 'spec_helper'

describe "AuthenticationPages" do

	subject { page }

	describe "signin page" do 
		before { visit signin_path }

		it { should have_selector('h1', text: 'Sign in') }
		it { should have_title('Sign in') }

		describe "sign in with invalid information" do 
		before { click_button "Sign in" }

		it { should have_title('Sign in') }		
		it { should have_selector('div.alert.alert-error') }
			
			# Test for persistence of flash error message. The issue is that flash 
			# messages persist for 1 request. However, we render 'new' with invalid 
			# login, which unlike 'redirect_to', does not count as a request.
			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		describe "sign in with valid information" do 
			let(:user) { create(:user) }
			before do 
				# using upcased email to be sure the downcase callback works
				fill_in "Email", with: user.email.upcase
				fill_in "Password", with: user.password
				click_button "Sign in"
			end

			it { should have_title(user.name) }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Sign out', href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }

			describe "followed by signout" do 
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
		end
	end
end
