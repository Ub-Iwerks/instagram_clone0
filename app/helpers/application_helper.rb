module ApplicationHelper
  require "uri"
  
  #ページ毎に完全なタイトルを返す。
  def full_title(page_title = "")
    base_title = "Instagram_clone"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  
  #渡された引数をハイパーリンク化する
  def text_url_to_link(text)
    URI.extract(text, ["http", "https"]).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"
      text.gsub!(url, sub_text)
    end
    return text
  end
  
end
