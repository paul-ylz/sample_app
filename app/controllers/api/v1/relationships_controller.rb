module Api
	module V1
		class RelationshipsController < Api::V1::BaseController

			before_action :authenticate 

			before_action :correct_user_for_creation, only: [:create]

			before_action :correct_user_for_destroy, only: [:destroy]

			def create
				user = get_user_from_auth_header
				user.follow!(User.find(params[:relationship][:follower_id]))
				render json: user.followed_users, status: 201
			end

			def destroy
				user = get_user_from_auth_header
				user.unfollow!(Relationship.find(params[:id]).followed)
				render json: user.followed_users, status: 200
			end

			private 

				def correct_user_for_creation
					render_unauthorized unless get_user_from_auth_header == User.find(params[:relationship][:follower_id])
				end

				def correct_user_for_destroy
					render_unauthorized unless get_user_from_auth_header == Relationship.find(params[:id]).follower
				end

		end
	end
end