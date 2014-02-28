class PasswordResetsController < ApplicationController

	before_action :set_user, only: [:edit, :update]
	before_action :check_token_expiry, only: [:edit, :update]
  
  def new
  end

  def create
  	user = User.find_by_email(params[:email])
  	user.send_password_reset if user 
  	redirect_to root_url, notice: "Email sent with password reset instructions"
  end

  def edit
  end

  def update
	  if @user.update_attributes(password_resets_params)
	  	@user.invalidate_password_reset
	    redirect_to root_url, :notice => "Password has been reset."
	  else
	    render :edit
	  end
  end

  private

	  def password_resets_params
	  	params.require(:user).permit(:password, :password_confirmation)
	  end

	  def set_user
	  	@user = User.find_by_password_reset_token(params[:id]) 
	  	redirect_to_new_with_message unless @user
	  end

	  def check_token_expiry 
			redirect_to_new_with_message if @user.password_reset_sent_at < 2.hours.ago
	  end

	  def redirect_to_new_with_message 
	  	redirect_to new_password_reset_url, alert: 'This password reset is no 
	  	longer valid, please request a new one'
	  end

	end
