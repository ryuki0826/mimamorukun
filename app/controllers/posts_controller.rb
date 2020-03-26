

class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}
  before_action :check_number_of_posts, {only: [:create, :import]}
  protect_from_forgery :except => ["create"]
  
  

  def index
    @posts = current_user.posts.all

    respond_to do |format|
      format.html 
       
      format.csv do
        send_data render_to_string, filename: "posts.csv", type: :csv
      end
    end
  end
  
 
  def new
    @post = Post.new
  end
  
  def create
     
    @post = current_user.posts.new(post_params)
    
    if !@post.sitecheck then 
      redirect_to posts_path, "サイト読み込みエラー。登録できませんでした"
      return
    end
    
    if @post.save
      redirect_to posts_path, notice: "監視サイト登録しました"  
    else
      redirect_to posts_path, notice: "システムエラー管理人までご連絡ください"           
    end
  end
  
  
  def edit
    
  end
  
  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: "監視サイト情報を編集しました"
    else
      render("posts/edit")
    end
  end
  
  def destroy
    @post.destroy
    redirect_to posts_url, notice: "監視登録を削除しました"
  end

  def destroyall
    @posts =Post.where(zaiko: false)
    @posts.destroy_all
    redirect_to posts_url, notice: "在庫切れのサイトの監視登録を全て削除しました"
  end

  def import
    err_msg=Post.import(params[:file])
    if err_msg.blank?	
      redirect_to posts_url ,notice: "登録完了しました"
    else
      redirect_to posts_url ,notice: "#{err_msg}について登録できませんでした"
    end
  end



  private

  def download
    download_file_name = "public/example.csv"
    send_file download_file_name
  end

  def post_params
    params.require(:post).permit(:url, :content, :content2, :option)
  end
  
end
