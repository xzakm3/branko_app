require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name: "Ahojko", email: "example@example.com", password: "barfoo", password_confirmation: "barfoo");
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 256
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[exampl@exampl.com I.am.@good.enough youand@me.in.harmony]
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test "email validation should not accept invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    duplicated_user = @user.dup
    duplicated_user.email = duplicated_user.email.upcase
    @user.save
    assert_not duplicated_user.valid?
  end

  test "name should be unique" do
    duplicated_user = @user.dup
    duplicated_user.email = "how@how.how"
    @user.save
    assert_not duplicated_user.valid?
  end

  test "name should be saved as lower-case" do
    mixed_case_name = "thisIsMynAMe"
    @user.name = mixed_case_name
    @user.save
    assert_equal mixed_case_name.downcase, @user.reload.name
  end

  test "email addresses should be save as lower-case" do
    mixed_case_email = "exAmPlE@EXampLE.cOm"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be nonblank" do
    @user.password = @user.password_confirmation = "        "
    assert_not @user.valid?
  end

  test "password should have minimum length 6 characters" do
    @user.password = @user.password_confirmation = "abcde"
    assert_not @user.valid?
  end
end
