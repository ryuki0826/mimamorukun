class Post < ApplicationRecord
  validates :content, {presence: true, length: {maximum: 50}}
  validates :content2, {length: {maximum: 50}}
  
  validates :user_id, {presence: true}
  
  def user
    return User.find_by(id: self.user_id)
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
