#require_relative 'zaikocheck_controller.rb'
namespace :zaiko do

    desc '在庫チェックのメールを送信。'
    
    task say_hello: :environment do
    
        users = User.all
        zaikocheck=ZaikocheckController.new
        
        users.each do |user|#ユーザー全員について繰り返し
            #あるユーザーが登録している商品サイトについて在庫確認する    
            message=zaikocheck.scraping(user)
            UserMailer.zaiko_check(user,message).deliver #在庫確認の結果をメールする
        end

    end

    desc 'test用のメールを送信。'

    task test: :environment do
    
        users = User.find_by(id:6)
        zaikocheck=ZaikocheckController.new
        
        # users.each do |user|#ユーザー全員について繰り返し
            #あるユーザーが登録している商品サイトについて在庫確認する    
            message=zaikocheck.scraping(user)
            UserMailer.zaiko_check(user,message).deliver #在庫確認の結果をメールする
        # end

    end



end


