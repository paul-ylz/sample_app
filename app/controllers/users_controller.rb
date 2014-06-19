class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy,
    :following, :followers]
  before_action :signed_in_user, only: [:edit, :update, :index,
    :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :no_signed_in_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts.page params[:page]
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      @user.send_email_confirmation
      redirect_to @user, flash: { :success =>
        'Welcome to the Sample App! Please check your email to activate your account.'
      }
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user, flash: { :success => 'Profile updated' }
    else
      render 'edit'
    end
  end

  def index
    # Chapter 9.33 Using the will_paginate gem.
    # Note params[:page] is generated automatically by will_paginate.
    # Default chunk size is 30 items.
    # @users = User.paginate(page: params[:page])

    # Using pg_search for full text search and kaminari gem to paginate
    @users = User.search(params[:query]).page params[:page]
  end

  def destroy
    if @user.destroy
      redirect_to users_url, flash: { success: "Deleted user: #{@user.name}"}
    end
  end

  def following
    @title = 'Following'
    @users = @user.followed_users.page params[:page]
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @users = @user.followers.page params[:page]
    render 'show_follow'
  end

  def activate
    @user = User.find_by_email_verification_token(params[:id])
    @user.set_active if @user
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
        :password_confirmation, :username, :notifications)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def correct_user
      redirect_to root_url unless current_user?(@user)
    end

    # Ex 9.6.9 Prevent admin users from deleting themselves.
    def admin_user
      redirect_to root_url unless current_user.admin? && (current_user != @user)
    end

    def no_signed_in_user
      redirect_to root_url if signed_in?
    end
end
