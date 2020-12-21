require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", username: "Example", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end
  
  test "username should be present" do
    @user.username = "   "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a"* 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a"* 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid address" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid address" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be valid"
    end
  end
  
  test "email address should unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "password should not be presence" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?
  end
  
  test "password should have minimunm length" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end
  
  test "posts should be destroyed when user is destroyed" do
    @user.save
    @user.posts.create!(content: "Yeah!")
    assert_difference "Post.count", -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow an user" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
  
  test "feed should have the right posts" do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)
    #フォローしているユーザーのポストがフィードに含まれていること
    lana.posts.each do |following_post|
      assert michael.feed.include?(following_post)
    end
    #自分自身のポストもフィードに含まれていること
    michael.posts.each do |self_post|
      assert michael.feed.include?(self_post)
    end
    #フォローしていないユーザーのポストがフィードに含まれていないこと
    archer.posts.each do |unfollowing_post|
      assert_not michael.feed.include?(unfollowing_post)
    end
  end
  
end
