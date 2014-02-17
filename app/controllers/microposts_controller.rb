class MicropostsController < ApplicationController

	before_action :signed_in_user

	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			redirect_to root_url, flash: { success: "Micropost created!" }
		else
			render 'static_pages/home'
		end
	end

	def destroy
	end

	private

		def micropost_params
			params.require(:micropost).permit(:content)
		end
end