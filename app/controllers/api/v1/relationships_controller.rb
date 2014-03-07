module Api
	module V1
		class RelationshipsController < Api::V1::BaseController

			before_action :authenticate 

			before_action :set_user

			before_action :check_for_relationship, only: :destroy

			def create
				@user.follow!(User.find(params[:id]))
				render json: @user, status: 201
			end

			def destroy
				@user.unfollow!(User.find(params[:id]))
				render json: @user, status: 200
			end

			private 

				def set_user
					@user = get_user_from_auth_header
				end

				def check_for_relationship
					target = @user.followed_users.find_by(id: User.find(params[:id]))
					render_not_found if target.nil?
				end

		end
	end
end