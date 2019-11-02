

class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}
  #スクレイピング用読み込み
  require 'nokogiri'
  require 'open-uri'


  def index
    @posts = Post.all.order(created_at: :desc)
  
  end
  
  def show
    @post = Post.find_by(id: params[:id])
    @user = @post.user
    @likes_count = Like.where(post_id: @post.id).count
  end
  
  def new
    @post = Post.new
   
  end
  
  def create
    @post = Post.new(
      content: params[:content],
      user_id: @current_user.id
    )
    if @post.save
      flash[:notice] = "投稿を作成しました"
      redirect_to("/posts/index")
    else
      render("posts/new")
    end
  end
  
  def edit
    @post = Post.find_by(id: params[:id])
  end
  
  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    if @post.save
      flash[:notice] = "投稿を編集しました"
      redirect_to("/posts/index")
    else
      render("posts/edit")
    end
  end
  
  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts/index")
  end
  
  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

  def scraping
    # 対象のURL
    url = "https://item.mercari.com/jp/m52572091689/"
    url2 ="https://item.mercari.com/jp/m52086832821"
    keyword="購入画面に進む"
    keyword2="売り切れました"
    # NokogiriでURLの情報を取得する
    @contents_url = Nokogiri::HTML(open(url),nil,"utf-8")
    @contents_url2 = Nokogiri::HTML(open(url2),nil,"utf-8")
 
    #puts @contents_url.content
    puts @contents_url.content.include?(keyword)
    puts @contents_url.content.include?(keyword2)
    puts @contents_url2.content.include?(keyword)
    puts @contents_url2.content.include?(keyword2)
  
  end
  
end
