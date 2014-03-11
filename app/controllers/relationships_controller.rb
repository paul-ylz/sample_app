class RelationshipsController < ApplicationController
	before_action :signed_in_user

	# Exercise 11.5.1 refacting with respond_to and respond_with
	respond_to :html, :js

	def create
		@user = User.find(params[:relationship][:followed_id])
		current_user.follow!(@user)
		respond_with @user
		@user.send_follower_notification(current_user)

		# respond_to do |format|
		# 	format.html { redirect_to @user }
		# 	format.js
		# end
	end

	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow!(@user)
		respond_with @user
		
		# respond_to do |format|
		# 	format.html { redirect_to @user }
		# 	format.js
		# end	
	end
end