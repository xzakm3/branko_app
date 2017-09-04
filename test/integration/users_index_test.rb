require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin, '1')
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.where(activated: true).paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'ul.users li>a[href=?]', user_path(user), text: user.name
      assert_select 'ul.users li>a[href=?]', user_path(user), text: 'delete'
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
      end
  end

  test "index as non-admin" do
    log_in_as(@non_admin, '1')
    get users_path
    assert flash.any?
    assert_redirected_to user_path(@non_admin)
    follow_redirect!
  end

end
