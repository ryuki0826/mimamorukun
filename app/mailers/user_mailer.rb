class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.zaiko_check.subject
  #
  def zaiko_check(user,message)
    @user=user
    @message =message
    mail to: "#{@user.email}",subject: "【みまもるくん】在庫状況のお知らせ"
  end
end
