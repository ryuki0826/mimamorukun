class ApplicationMailer < ActionMailer::Base
  #1113 送信元変更
  default from: 'mimamorukunn2@gmail.com'
  layout 'mailer'
end
