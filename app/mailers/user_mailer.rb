class UserMailer < ActionMailer::Base
  default from: "noreply@kidsplaymath.com"

  def welcome_email(user)
  	@user = user
  	mail to: user.email, subject: 'Account Invitation'
  end
end
