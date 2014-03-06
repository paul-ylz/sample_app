# Ex 5.6.4 Instead of duplicating the full_title method from application_helper
# in spec_helper, we do 2 things: 
# 1. Write a test for helper method (in spec/helpers/application_helper_spec.rb)
# 2. Create spec/support/utilities.rb and include ApplicationHelper to make
# helper methods available in ours tests.

include ApplicationHelper

# Chap 8.34 Adding spec helpers to decouple the tests
def sign_in(user, options={})
	if options[:no_capybara]
		remember_token = User.new_remember_token
		cookies[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
	else
		visit signin_path
		# using upcased email to be sure the downcase callback works
		fill_in "Email", with: user.email.upcase
		fill_in "Password", with: user.password
		click_button "Sign in"
	end
end

def set_http_authorization_header(user)
	request.env["HTTP_AUTHORIZATION"] = ActionController::HttpAuthentication::Token.encode_credentials(user.api_key.access_token)
end

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		expect(page).to have_selector('div.alert.alert-error', text: message)
	end
end

RSpec::Matchers.define :have_signed_in_links do |user|
	match do |page|
		# expect(page).to have_title(user.name)
		expect(page).to have_link('Profile', href: user_path(user))
		expect(page).to have_link('Sign out', href: signout_path)
		expect(page).to have_link('Settings', href: edit_user_path(user))
		expect(page).to have_link('Users', href: users_path)
	end
end