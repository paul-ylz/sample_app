class MicropostsController < ApplicationController

	include ReplyParser
	include MessageHandler

	before_action :signed_in_user
	before_action :correct_user, only: :destroy
	before_action :check_if_message, only: :create

	def create
		@micropost = current_user.microposts.build(micropost_params)
		
		parse_recipient!(@micropost)

		if @micropost.save
			redirect_to root_url, flash: { success: "Micropost created" }
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_url, flash: { success: "Micropost deleted" }
	end

	private

		def micropost_params
			params.require(:micropost).permit(:content)
		end

		def correct_user 
			# if object does not exist, Object.find will raise exception. 
			# Object.find_by will return nil instead.
			@micropost = current_user.microposts.find_by(id: params[:id])
			redirect_to root_url if @micropost.nil?
		end
end