require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup infomation" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "", email: "user@invalid", password:"for", password_confirmation:"bar" } }
    end
    assert_template "users/new"
    assert_select "div#error_explanation"
    assert_select "div.alert-danger"
  end
  
  test "valid signup infomation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User", username: "Example", email: "user@example.com", password: "password", password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?   
    assert_not flash.empty?
  end
  
end
