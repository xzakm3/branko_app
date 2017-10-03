require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do
    @admin = users(:michael)
    log_in_as(@admin, '1')
    assert_not_nil cookies['remember_token']
    get signup_user_path
    assert_select 'form[action="/users"]'
    assert_no_difference 'User.count' do
      post signup_user_path, params: {user: {
          name: "",
          email: "example@example.com",
          password: "foobar",
          password_confirmation: "foobar"
      }}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
  end

  test "valid signup information" do
    @admin = users(:michael)
    log_in_as(@admin, '1')
    get signup_user_path
    assert_select 'form[action="/users"]'
    assert_difference 'User.count',1 do
      post signup_user_path, params: {user: {
          name: "misinecko",
          email: "misinecko@misinecko.misinecko",
          password: "misinecko",
          password_confirmation: "misinecko"
      }}
    end
    assert_not flash.empty?
=begin
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user, '1')
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid email address and activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'sessions/new'
    assert flash.any?
=end
  end

end
