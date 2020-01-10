class Post < ApplicationRecord
  validates :content, {presence: true, length: {maximum: 50}}
  validates :content2, {length: {maximum: 50}}
  validates :url, {presence: true}
  validates :user_id, {presence: true}
  
  def user
    return User.find_by(id: self.user_id)
  end


  belongs_to :user

 validate :check_number_of_posts

#  def check_number_of_posts on: :new
#   if user.account == 3 && user.posts.size >14
#    errors.add(:post, "登録上限を超えています。アカウントをアップグレードしてください。")

#   end
#  end

 def check_number_of_posts
  if user.account == 0 && user.posts.size >19
   errors.add(:post, "登録上限を超えています。アカウントをアップグレードしてください。")
  elsif user.account == 1 && user.posts.size >99
   errors.add(:post, "登録上限を超えています。アカウントをアップグレードしてください。")
  elsif user.account == 2 && user.posts.size >299
    errors.add(:post, "登録上限を超えています。アカウントをアップグレードしてください。")
  elsif user.account == 3 && user.posts.size >999
      errors.add(:post, "登録上限を超えています。")
  else  
  
  end
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
