class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.zaiko_check.subject
  #
  def zaiko_check(user)
    @user=user
    
    mail to: "#{@user.email}",subject: "Hello,#{@user.name}"
  end
end
