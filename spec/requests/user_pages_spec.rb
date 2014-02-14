require 'spec_helper'

describe "UserPages" do

	subject { page }

	describe "signup page" do 
		before { visit signup_path }

		# Ex 5.6.1 Using Capybara's have_selector
		# replace:
		# it { should have_content('Sign up') }
		# with:
		it { should have_selector('h1', text: 'Sign up') }

		it { should have_title(full_title('Sign up')) }
	end
end
