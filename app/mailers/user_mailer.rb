class UserMailer < ActionMailer::Base
  default from: "noreply@sample_app.com"

  def follower_notification(followed, follower)
  	@followed = followed 
  	@follower = follower
  	mail(to: "#{followed.name} <#{followed.email}>", 
  		subject: "You have a new follower")
  end
end
