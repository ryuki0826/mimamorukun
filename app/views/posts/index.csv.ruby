require 'csv'

CSV.generate do |csv|
  csv_column_names = ["URL","Stock","Option"]
  csv << csv_column_names
  @posts.each do |post|
    csv_column_values = [
      post.url,
      post.zaiko,
      post.option,
    ]
    csv << csv_column_values
  end
end