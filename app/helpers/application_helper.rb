module ApplicationHelper
  require "uri"
  
  #デフォルトのviewデータ
  def default_meta_tags
  {
    site: 'Instagram_clone',
    reverse: true,
    charset: 'utf-8',
    description: 'Create an account or log in to Instagram_clone - A simple, fun & creative way to capture, edit & share photos, videos & messages with friends & family.',
    keywords: 'Instagram,clone,Ruby,Rails',
    canonical: request.original_url,
    separator: '•'
}
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
