module ApplicationHelper
    require "uri"
    #URL文字列をハイパーリンク化
 
    def text_url_to_link(text)

        URI.extract(text, ["http", "https"]).uniq.each do |url|#http or https で始まるテキスト要素の重複削除
          text.gsub!(url, "<a href=\"#{url}\" target=\"_blank\">#{url.truncate(50)}</a>")#ハイパーリンク化 表示する文字列は50文字までに制限
        end
        text
      end

end
