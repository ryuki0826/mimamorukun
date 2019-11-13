

class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}
  
   #スクレイピング用読み込み
   require 'nokogiri'
   require 'open-uri'

  def index
    #@posts = Post.all.order(created_at: :desc)
    @posts = Post.all.order(created_at: :desc)
    @posts=Post.where(user_id: @current_user.id)
  end
  
  # def show
  #   @post = Post.find_by(id: params[:id])
  #   @user = @post.user
  #   @likes_count = Like.where(post_id: @post.id).count
  # end
  
  def new
    @post = Post.new
   
  end
  
  def create
    @post = Post.new(
      url: params[:url],
      content: params[:content],
      user_id: @current_user.id
    )
    #サイト読み取り異常の場合　登録不可のメッセージ追加
    if sitecheck(@post.url)
    
      if @post.save
        flash[:notice] = "監視サイト登録しました"
        redirect_to("/posts/index")
      else
        render("posts/new")
      end

    else

      flash[:notice] = "ＵＲＬが不適切かそのサイトからアクセスブロックされているため登録できません"
      redirect_to("/posts/index")
    end
  end
  
  #読み込みエラーが発生したときのみfalse返す
  def sitecheck(url)
    judge=true

    url_ob=URI::parse(url)
    begin
        #HTTPEROORが発生した場合のエラー処理
        page=url_ob.read("user-agent"=>"aaaa")
    rescue

      judge=false
    end

    return judge
  end
  
  def edit
    @post = Post.find_by(id: params[:id])
  end
  
  def update
    @post = Post.find_by(id: params[:id])

    @post.content = params[:content]
    @post.url= params[:url]
    if @post.save
      flash[:notice] = "監視サイト情報を編集しました"
      redirect_to("/posts/index")
    else
      render("posts/edit")
    end
  end
  
  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "監視登録を削除しました"
    redirect_to("/posts/index")
  end
  
  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end



  
  
end
