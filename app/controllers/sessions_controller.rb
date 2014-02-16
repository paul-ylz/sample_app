class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by(email: params[:email].downcase)
		if user && user.authenticate(params[:password])
			sign_in user 
			redirect_back_or(user)
		else
			# Chap 8.12
			# Flash messages persist for 1 request. Unlike 'redirect_to', render does
			# not count as a request, resulting in an error that persists for a further 
			# request. The solution is to call flash.now.
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'			
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
