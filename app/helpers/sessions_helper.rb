module SessionsHelper

	# Chap 8.19 Create a new remember token with every sign in
	def sign_in(user)
		remember_token = User.new_remember_token
		# Chap 8.19 cookies.permanent sets expiry to 20 years
		cookies.permanent[:remember_token] = remember_token
		# Use update_attribute to bypass validations.
		user.update_attribute(:remember_token, User.encrypt(remember_token))
		self.current_user = user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		remember_token = User.encrypt(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		# change the token in case its been stolen
		current_user.update_attribute(:remember_token, User.encrypt(User.new_remember_token))
		# delete the cookie
		cookies.delete(:remember_token)
		self.current_user = nil
	end
end
