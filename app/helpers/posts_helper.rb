module PostsHelper
  
  def display_image(post, option = {resize:"500x500^", crop:"500x500+0+0"} )
    image = post.image
    resize = option[:resize]
    crop = option[:crop]
    image.variant(gravity: :center, resize: resize, crop: crop).processed
  end
  
end
