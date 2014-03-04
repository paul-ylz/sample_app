module Api
	module V1 
		class UsersController < ApplicationController

			protect_from_forgery with: :null_session			

			respond_to :json

			def index
				respond_with User.all 
			end

			def show
				respond_with User.find(params[:id])
			end

			def create
				respond_with User.create(user_params)
			end

			def update
				respond_with User.update(params[:id], user_params)
			end

			def destroy
				respond_with User.destroy(params[:id])
			end

			def following
				respond_with User.find(params[:id]).followed_users
			end

			def followers
				respond_with User.find(params[:id]).followers
			end

			private

			def user_params
    	params.require(:user).permit(:name, :email, :password, 
        :password_confirmation, :username, :notifications)
	    end

		end
	end
end