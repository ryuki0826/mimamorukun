module ApplicationHelper
    require "uri"
    #URL文字列をハイパーリンク化
 
    def text_url_to_link(text)

        URI.extract(text, ["http", "https"]).uniq.each do |url|#http or https で始まるテキスト要素の重複削除
          text.gsub!(url, "<a href=\"#{url}\" target=\"_blank\">#{url.truncate(50)}</a>")#ハイパーリンク化 表示する文字列は50文字までに制限
        end
        text
    end
    
    def convert_account(accountnumber)
        if accountnumber == 0 or accountnumber.blank?
          "フリー"
        elsif accountnumber == 1
          "スターター"
        elsif accountnumber == 2
          "スタンダード"
        elsif accountnumber == 3
          "プロフェッショナル"
        else
          ""
        end
    end

    def convert_kanshimax(accountnumber)
        if accountnumber == 0 or accountnumber.blank?
          10  
        elsif accountnumber == 1
          100
        elsif accountnumber == 2
          300
        elsif accountnumber == 3
          1000
        else
          ""
        end
    end
    
    def convert(flag)
      if flag
        "あり"
      else
        "なし"
      end
    end 

end
