def set_http_authorization_header(user)
  request.env["HTTP_AUTHORIZATION"] = ActionController::HttpAuthentication::Token.encode_credentials(user.api_key.access_token)
end