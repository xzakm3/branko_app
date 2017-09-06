require 'test_helper'

class FarmMailerTest < ActionMailer::TestCase
  test "farm_information" do
    mail = FarmMailer.farm_information
    assert_equal "Farm information", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
