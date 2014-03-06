module Api
	module V1
		class RelationshipsController < Api::V1::BaseController

			before_action :correct_user

			def create
				followed = User.find(params[:relationship][:followed_id])
				current_user.follow!(followed)
				render json: current_user.followed_users, status: 201
			end


			private 

				def current_user
					User.find(params[:relationship][:follower_id])
				end
		end
	end
end
