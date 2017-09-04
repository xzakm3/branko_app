require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "unsuccessful edit" do
    log_in_as(@user, '1')
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {
        name: "",
        email: "foo@invalid.com",
        password: "foo",
        password_confirmation: "bar"
    }}

    assert_template 'users/edit'
    assert_select "div.alert", "The form contains 3 errors."
  end

  test "successfull edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user, '1')
    assert_redirected_to edit_user_url(@user)
    follow_redirect!
    assert_template 'users/edit'
    name = "Elisa Tee"
    email = "elisatee@gmail.com"
    patch user_path(@user), params: {user: {
        name: name,
        email: email,
        password: "",
        password_confirmation: ""
    }}

    assert_not flash.empty?
    assert_redirected_to @user
    follow_redirect!
    @user.reload
    assert_equal @user.name, name.downcase
    assert_equal @user.email, email
  end

  test "should redirect edit when user not logged_in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
    follow_redirect!
  end

  test "should redirect update when user not logged in" do
    patch user_path(@user), params: {user: {
        name: @user.name,
        email: @user.email
    }}
    assert_not flash.empty?
    assert_redirected_to login_path
    follow_redirect!
  end

  test "should redirect show when user not logged in" do
    get user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
    follow_redirect!
  end

  test "should redirect edit when user logged in as wrong user" do
    log_in_as(@other_user, '1')
    get edit_user_path(@user)
    assert_redirected_to @other_user
    follow_redirect!
  end

  test "should redirect update when user logged in as wrong user" do
    log_in_as(@other_user, '1')
    patch user_path(@user), params: {user: {
        name: @user.name,
        email: @user.email
    }}
    assert_redirected_to @other_user
    follow_redirect!
  end

  test "should redirect show when user logged in as wrong user" do
    log_in_as(@other_user, '1')
    get user_path(@user)
    assert_redirected_to @other_user
    follow_redirect!
  end
end
