# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/zaiko_check
  def zaiko_check
    UserMailer.zaiko_check(User.first)
  end

end
