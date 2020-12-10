module UsersHelper
  
  #引数で与えられたユーザーにgravatar画像を返すメソッド
  def gravatar_for(user, option = {size: 80} )
    size = option[:size]
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
end
