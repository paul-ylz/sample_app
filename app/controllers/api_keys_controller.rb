class ApiKeysController < ApplicationController

  def create
    current_user.create_api_key
    redirect_to edit_user_url(current_user)
  end
end
