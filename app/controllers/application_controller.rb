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
  
  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if current_user.id !=@post.user_id
      flash[:notice] = "権限がありません"
      redirect_to(posts_url)
    end
  end
  
  # #deviceログイン時実行し、ページ遷移させる
  # def after_sign_in_path_for(resource)
  #       flash[:notice] = "ログインできました" 
  #       posts_index
  # end
  
  #ログイン中の場合にはpost/index画面に強制移動
  def forbid_login_user
    if user_signed_in?
      flash[:notice] = "ログイン中です"
      redirect_to(posts_url)
    end
  end

  #ポストがアカウント上限以内かどうか確認。
  def check_number_of_posts
    if (current_user.account ==0  or current_user.account.blank?) && current_user.posts.size >9
      redirect_to edit_user_registration, notice: "登録上限を超えています。さらなる利用にはアカウントのアップグレードが必要です。"
    elsif current_user.posts.size >499
      redirect_to edit_user_registration, notice: "登録上限を超えています。"
    end
  end

 
  

  


end
