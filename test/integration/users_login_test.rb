require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
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
  end

  test "login with valid information and role is admin" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {
        name: @admin.name,
        password: 'testtest'
    }}
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path, count: 1
    assert_select "a[href=?]", user_path(@admin), count: 1
    assert_select "a[href=?]", users_path, count: 1
  end

  test "login with valid information and role is regular_user" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {session: {
        name: @non_admin.name,
        password: 'testtest'
    }}
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path, count: 1
    assert_select "a[href=?]", user_path(@non_admin), count: 1
    assert_select "a[href=?]", users_path, count: 0
  end

  test "login with valid information followed by logout" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {
        name: @admin.name,
        password: 'testtest'
    }}
    follow_redirect!
    assert is_logged_in?
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path, count: 1
    assert_select "a[href=?]", user_path(@admin), count: 1
    assert_select "a[href=?]", users_path, count: 1
    delete logout_path
    assert_not is_logged_in?
    follow_redirect!
    assert_template root_path
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@admin), count: 0
    assert_select "a[href=?]", users_path, count: 0
  end

  test "login with remembering" do
    log_in_as(@admin, '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@admin, '0')
    assert_nil( cookies['remember_token'])
  end

end
