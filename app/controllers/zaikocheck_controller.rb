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
            error_text_url=""
            i=0
        
            urls.each do |url|
                    
                    
                    # url=Post.find_by(url: url.url)
                    url.content2=url.content if url.content2.blank? #複数キーワード対応　もっと良い方法ありそう 20191126修正　blank?利用(nil, "", " ", [], {} のいずれかでTrueを返す。)
                    keyword=url.content
                    keyword2=url.content2                
                    
                begin
                    #HTTPEROORが発生した場合のエラー処理
                    url_ob=URI::parse(url.url)
                    page=url_ob.read("user-agent"=>"aaaa")
                    @contents_url = Nokogiri::HTML::parse(page)
                rescue
                    error_text_url << url.url
                    error_text_url << "\n"
                    next
                end
                    
                
                    #@contents_url = Nokogiri::HTML(open(url.url),nil,"utf-8")
                #キーワード発生⇒url.zaiko=false　保存できなかったらerror_text_urlにURL入力
                if @contents_url.content.include?(keyword) or @contents_url.content.include?(keyword2) 
                    url.zaiko=false
                    #保存OK⇒text_url 保存NG⇒error_text_url
                    if url.save
                        text_url << url.url
                        text_url << "\n"
                        i+=1
                    else
                        error_text_url << url.url
                        error_text_url << "\n"
                        
                    end

                   
                else
                    url.zaiko=true
                    url.save
                end

                # if @contents_url.content.include?(keyword) or @contents_url.content.include?(keyword2) 
                #     url.zaiko=false
                #     text_url << url.url
                #     text_url << "\n"
                #     i+=1
                # else
                #     url.zaiko=true
                # end

                #変更内容を更新
                
           
            end

            
           

        

        
            if error_text_url==""
                return "#{i}件のウェブサイトでキーワードが発生しております\n#{text_url}"+"\n" 
            else
                return "#{i}件のウェブサイトでキーワードが発生しております\n#{text_url}"+"\n"+ "在庫確認時、以下のサイトで通信エラー発生しております。在庫状況確認お願いします。\n#{error_text_url}"
            end

    end

   
end
