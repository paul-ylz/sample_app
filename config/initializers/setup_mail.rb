ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "sampleapp.com",
  :user_name            => "exampleapp9",
  :password             => "eightchars",
  :authentication       => "plain",
  :enable_starttls_auto => true
}