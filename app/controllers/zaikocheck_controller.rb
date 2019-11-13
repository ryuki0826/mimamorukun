class ZaikocheckController < ApplicationController

#スクレイピング用読み込み
require 'nokogiri'
require 'open-uri'

    #ユーザーが登録しているサイトをスクレイピングして、在庫状況を確認
    #在庫有りの場合true 無の場合 falseを入力
    def scraping(user)
        # ユーザーの登録サイトの数だけ繰り返す
        urls=Post.where(user_id: user.id)
        text_url= ""
        i=0
        urls.each do |url|
            r_item=Post.find_by(url: url.url)
            keyword=r_item.content
        
            url_ob=URI::parse(url.url)
            page=url_ob.read("user-agent"=>"aaaa")
            @contents_url = Nokogiri::HTML::parse(page)
           
            #@contents_url = Nokogiri::HTML(open(r_item.url),nil,"utf-8")
           
            if @contents_url.content.include?(keyword)
                r_item.zaiko=false
                text_url << r_item.url
                text_url << "\n"
                i+=1
            else
                r_item.zaiko=true
            end
            
           
        #変更内容を更新
        r_item.save     
        end

        return "在庫切れは#{i}件ありました\n#{text_url}"+"\n" 
    

    end

    # def scraping(user)
    #     # ユーザーの登録サイトの数だけ繰り返す
    #     urls=Post.where(user_id: user.id)
    #     text_url= ""
    #     i=0
    #     urls.each do |url|
    #         r_item=Post.find_by(url: url.url)
    #         keyword=r_item.content
        
    #         @contents_url = Nokogiri::HTML(open(r_item.url),nil,"utf-8")
           
    #         if @contents_url.content.include?(keyword)
    #             r_item.zaiko=false
    #             text_url << r_item.url
    #             text_url << "\n"
    #             i+=1
    #         else
    #             r_item.zaiko=true
    #         end
            
           
    #     #変更内容を更新
    #     r_item.save     
    #     end

    #     return "在庫切れは#{i}件ありました\n#{text_url}"+"\n" 
        

        

      
        
      

    # end

end
