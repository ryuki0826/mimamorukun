class Post < ApplicationRecord
  validates :content, {presence: true, length: {maximum: 50}}
  validates :content2, {length: {maximum: 50}}
  validates :url, {presence: true}
  validates :user_id, {presence: true}
  
  # def user
  #   return User.find_by(id: self.user_id)
  # end


  belongs_to :user

#  validate :check_number_of_posts

#  def check_number_of_posts on: :new
#   if user.account == 3 && user.posts.size >14
#    errors.add(:post, "登録上限を超えています。アカウントをアップグレードしてください。")

#   end
#  end


 #サイトへアクセス可能か判断し、true,false返す。可能なら在庫確認もする。
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

  # def self.import(file)
  #   CSV.foreach(file.path, headers: true, encoding: 'Shift_JIS:UTF-8') do |row|

  #     Post.create(url: row['url'],
  #                 content: row['content'],
  #                 content2: row['content2'],
  #                 user_id: @current_user.id)
  #     # post.attributes = row.to_hash.slice(*updatable_attributes)

  #     # post.save!
  #   end
  # end

  # def self.updatable_attributes
  #   ["url","content","content2"]
  # end
end
