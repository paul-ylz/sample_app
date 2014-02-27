ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "sampleapp.com",
  :user_name            => "exampleapp9",
  :password             => "eightchars",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = 'http://morning-beach-8502.herokuapp.com'