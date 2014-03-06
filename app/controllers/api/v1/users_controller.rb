module Api
	module V1 
		class UsersController < ApplicationController 

			protect_from_forgery with: :null_session

			before_action :authenticate, only: [:index, :update, :following, 
				:followers, :destroy]

			before_action :correct_user, only: [:update]

			before_action :admin_user, only: [:destroy]


			def index
				# requests in curl return status 204 instead of 200 when using respond_with
				render json: User.all
			end

			def show
				render json: User.find_by_id(params[:id])
			end

			def create
				render json: User.create(user_params), status: 201
			end

			def update
				user = User.find(params[:id])
				user.update(user_params)
				render json: user
			end

			def destroy
				render json: User.destroy(params[:id])
			end

			def following
				render json: User.find(params[:id]).followed_users
			end

			def followers
				render json: User.find(params[:id]).followers
			end


			private

				def user_params
		    	params.require(:user).permit(:name, :email, :password, 
		    		:password_confirmation, :username, :notifications)
		    end

		    def authenticate
		    	authenticate_token || render_unauthorized
		    end

		    def authenticate_token
		    	authenticate_with_http_token do |token, options|
		    		ApiKey.exists?(access_token: token)
		    	end
		    end

		    def render_unauthorized
		    	self.headers['WWW-Authenticate'] = 'Token realm="Application"'
		    	render json: 'Bad credentials', status: 401
		    end

				def correct_user
					head :unauthorized unless get_user_from_auth_header == current_user
				end

				def current_user 
					User.find(params[:id])
				end

				def admin_user
					head :unauthorized unless get_user_from_auth_header.admin?
				end

				# def get_user_from_auth_header
				# 	token = request.headers['Authorization'].match(/[^Token token="]\w+/).to_s
				# 	ApiKey.find_by_access_token(token).user
				# end
				def get_user_from_auth_header
					token_params = ActionController::HttpAuthentication::Token.token_params_from(request.headers['Authorization'])
					ApiKey.find_by_access_token(token_params[0][1]).user
				end

		end
	end
end