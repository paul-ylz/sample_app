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

	# Chap 9.15
	def current_user?(user)
		# Note: user is a local variable, whereas current_user is an attribute of 
		# the current session, which could be more explicitly defined as 
		# self.current_user
 		current_user == user 
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		# change the token in case its been stolen
		current_user.update_attribute(:remember_token, 
			User.encrypt(User.new_remember_token))
		# delete the cookie
		cookies.delete(:remember_token)
		self.current_user = nil
	end

	# Chap 9.17 Friendly forwarding implementation
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	# Store the requested GET url, available in the rails request object, in the 
	# Rails session (we create the :return_to key)
	def store_location
		session[:return_to] = request.url if request.get?
	end
end
