module ApiHelper 

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

	def get_user_from_auth_header
    if request.headers['Authorization'].nil?
      render_unauthorized && return 
    else
  		token_params = ActionController::HttpAuthentication::Token.token_params_from(request.headers['Authorization'])
  		ApiKey.find_by_access_token(token_params[0][1]).user
    end
	end

end