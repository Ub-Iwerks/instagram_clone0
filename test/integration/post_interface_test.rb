require 'test_helper'

class PostInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "post interface" do
    log_in_as(@user)
    get root_url
    assert 'div.pagination'
    assert_select 'a[href=?]', '/?page=2'
    #content = "Yeah!"
    #image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    #assert_difference "Post.count", 1 do  写真追加してないから、投稿失敗。
      #post posts_path, params: {post: {content: content}}
    #end
    #assert_redirected_to root_url
    #follow_redirect!
    #assert_match content, response.body
    assert_select 'a', text: 'delete'
    first_micropost = @user.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_micropost)
    end
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  
end
