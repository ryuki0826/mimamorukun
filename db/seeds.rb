3.times do |index|
  no = index + 1
  user = User.create(
    email:  "email_#{no}@example.com",
    password:               "#{no}password#{no}",
    password_confirmation:  "#{no}password#{no}",
  )
  user.save!
end