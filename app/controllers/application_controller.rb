class ApplicationController < ActionController::Base
  

  # before_action :set_current_user
  
  # def set_current_user
  #   @current_user = User.find_by(id: session[:user_id])
  # end
  
  def authenticate_user
    if current_user == nil
      flash[:notice] = "ログインが必要です"
      redirect_to("users/sign_in")
    end
  end
  
  def forbid_login_user
    if user_signed_in?
      flash[:notice] = "ログイン中です"
      redirect_to("/posts/index")
    end
  end

  #ポストがアカウント上限以内かどうか確認。上限以内true 。上限オーバーfalse返す
def check_number_of_posts

  if (current_user.account ==0  or current_user.account.blank?) && current_user.posts.size >9
      flash[:notice] = "登録上限を超えています。さらなる利用にはアカウントのアップグレードが必要です。"
      return false
  elsif current_user.posts.size >499
      flash[:notice] = "登録上限を超えています。"
      return false
  else  
      return true
  end
end

 
  

  


end
