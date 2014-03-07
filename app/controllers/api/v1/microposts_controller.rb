module Api
	module V1 
		class MicropostsController < Api::V1::BaseController 

			before_action :authenticate

			def create
				user = get_user_from_auth_header
				render json: 
					user.microposts.create(content: params[:micropost][:content]), 
					status: 201
			end

			def destroy
				micropost = get_user_from_auth_header.microposts.find_by(id: params[:id])
				if micropost.nil?
					render json: 'Not found', status: 404
				else 
					render json: micropost.destroy, status: 200
				end
			end

		end
	end
end