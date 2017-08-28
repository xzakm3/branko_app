require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "should get new" do
    get users_new_url
    assert_response :success
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_path
    follow_redirect!
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@non_admin)
    end
    assert_redirected_to login_url
    follow_redirect!
  end

  test "should redirect destroy when logged in as non-admin" do
    log_in_as(@non_admin, '1')
    assert_no_difference 'User.count' do
      delete user_path(@non_admin)
    end
    assert_redirected_to user_path(@non_admin)
  end

end
