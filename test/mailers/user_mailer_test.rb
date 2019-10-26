require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "zaiko_check" do
    mail = UserMailer.zaiko_check
    assert_equal "Zaiko check", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
