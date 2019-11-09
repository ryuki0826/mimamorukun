class ZaikoCheck

#スクレイピング用読み込み
require 'nokogiri'
require 'open-uri'

    #ユーザーが登録しているサイトをスクレイピングして、在庫状況を確認
    #在庫有りの場合true 無の場合 falseを入力
    def scraping(user)
        # ユーザーの登録サイトの数だけ繰り返す
        urls=Post.where(user_id: user.id)
        
        urls.each do |url|      
            post=Post.find_by(url: url)
            keyword=post.content
            
            @contents_url = Nokogiri::HTML(open(url),nil,"utf-8")
            if @contents_url.content.include?(keyword)
                post.zaiko=true
            else
                post.zaiko=false
            end
        
        #変更内容を更新
        post.save     
        end

      
        
      

    end
end


   
