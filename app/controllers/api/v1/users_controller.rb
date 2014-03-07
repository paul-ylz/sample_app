module Api
	module V1 
		class UsersController < Api::V1::BaseController 

			before_action :authenticate, only: [:index, :update, :following, 
				:followers, :destroy, :feed]

			before_action :correct_user, only: [:update]

			before_action :admin_user, only: [:destroy]


			def index
				render json: User.all, status: 200
			end

			def show
				render json: User.find_by_id(params[:id]), status: 200
			end

			def create
				render json: User.create(user_params), status: 201
			end

			def update
				user = User.find(params[:id])
				user.update(user_params)
				render json: user, status: 200
			end

			def destroy
				render json: User.destroy(params[:id]), status: 200
			end

			def following
				render json: User.find(params[:id]).followed_users, status: 200
			end

			def followers
				render json: User.find(params[:id]).followers, status: 200
			end

			def feed
				user = get_user_from_auth_header
				render json: user.feed, status: 200
			end


			private

				def user_params
		    	params.require(:user).permit(:name, :email, :password, 
		    		:password_confirmation, :username, :notifications)
		    end

		    def correct_user
					render_unauthorized unless get_user_from_auth_header == User.find(params[:id])
				end

				def admin_user
					render_unauthorized unless get_user_from_auth_header.admin?
				end
		end
	end
end