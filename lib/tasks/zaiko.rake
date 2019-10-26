namespace :zaiko do

    desc '在庫チェックのメールを送信。'
    
    task say_hello: :environment do
    
        users = User.all
        users.each do |user|
            UserMailer.zaiko_check(user).deliver
        end

    end

end
