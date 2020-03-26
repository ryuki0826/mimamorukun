class Post < ApplicationRecord
  validates :content, {presence: true, length: {maximum: 50}}
  validates :content2, {length: {maximum: 50}}
  validates :url, {presence: true}
  validates :user_id, {presence: true}
  
   #スクレイピング用読み込み
   require 'nokogiri'
   require 'open-uri'

  belongs_to :user



 #サイトへアクセス可能か確認。可能なら在庫確認もする。
  def sitecheck
    judge=true
    begin
        #HTTPEROORが発生した場合のエラー処理
        url_ob=URI::parse(self.url)
        page=url_ob.read("user-agent"=>"aaaa")
        @contents_url = Nokogiri::HTML::parse(page)
        self.content2=self.content if self.content2.blank? #複数キーワード対応　もっと良い方法ありそう 20191126修正　blank?利用(nil, "", " ", [], {} のいずれかでTrueを返す。)
        keyword=self.content
        keyword2=self.content2                
                  
        if @contents_url.content.include?(keyword) or @contents_url.content.include?(keyword2) 
          self.zaiko=false
        else
          self.zaiko=true
        end
    rescue
  
      judge=false
    end
  
    return judge
  end

  def self.import(file)
    
   err_url = ""
    
    CSV.foreach(file.path, headers: true, encoding: 'Shift_JIS:UTF-8') do |row|
      
      post= new
      post.attributes = row.to_hash.slice(*updatable_attributes)
      
       #サイトアクセス可能か判定
      if !post.sitecheck then 
        err_url=err_url + post.url.to_s + "\n"
        next
      end
      
      if !post.save then 
        err_url=err_url + post.url.to_s + "\n"          
      end
    end
    
    return err_url
  end

  def self.updatable_attributes
    ["url","content","content2"]
  end
end
