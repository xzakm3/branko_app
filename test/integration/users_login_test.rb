require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end


  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {
        name: "jozko",
        password: "neviemcouz"
    }}
    assert_template 'sessions/new'
    assert flash.any?
    get signup_path
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {
        name: @user.name,
        password: 'testtest'
    }}
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path, count: 1
    assert_select "a[href=?]", user_path(@user), count: 1
  end

  test "login with valid information followed by logout" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {
        name: @user.name,
        password: 'testtest'
    }}
    follow_redirect!
    assert is_logged_in?
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path, count: 1
    assert_select "a[href=?]", user_path(@user), count: 1
    delete logout_path
    follow_redirect!
    assert_template root_path
    assert_not is_logged_in?
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

end
