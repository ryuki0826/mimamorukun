

class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}
  protect_from_forgery :except => ["create"]
   #スクレイピング用読み込み
   require 'nokogiri'
   require 'open-uri'

  def index
    #@posts = Post.all.order(created_at: :desc)
    @posts = Post.all.order(created_at: :desc)
    @posts=Post.where(user_id: @current_user.id)

    respond_to do |format|
      format.html 
       
      format.csv do
        send_data render_to_string, filename: "posts.csv", type: :csv
      end
    end
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
      content2: params[:content2],
      option: row['option'],
      user_id: @current_user.id
    )
   
    #サイト読み取り異常の場合　登録不可のメッセージ追加　サイトチェックをモデルに移動させるとスマートになりそ
    if sitecheck(@post) 
      
      if @post.save
        flash[:notice] = "監視サイト登録しました"
        redirect_to("/posts/index")
      else
        render("posts/new")
      end

    else

      flash[:notice] = "サイト読み込みエラー。登録できませんでした"
      render("posts/new")
      # redirect_to("/posts/new")
    end
  end
  
  #読み込みエラーが発生したときのみfalse返す
  #引数はpostオブジェクト
  def sitecheck(obPost)
    judge=true

    begin
        #HTTPEROORが発生した場合のエラー処理
        url_ob=URI::parse(obPost.url)
        page=url_ob.read("user-agent"=>"aaaa")
        @contents_url = Nokogiri::HTML::parse(page)
        obPost.content2=obPost.content if obPost.content2.blank? #複数キーワード対応　もっと良い方法ありそう 20191126修正　blank?利用(nil, "", " ", [], {} のいずれかでTrueを返す。)
        keyword=obPost.content
        keyword2=obPost.content2                
                  
        if @contents_url.content.include?(keyword) or @contents_url.content.include?(keyword2) 
          obPost.zaiko=false
        else
          obPost.zaiko=true
        end
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
    @post.content2 = params[:content2]
    @post.url= params[:url]
    @post.option=params[:option]
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

  def destroyall
    @posts =Post.where(zaiko: false)
    @posts.destroy_all
    flash[:notice] = "在庫切れのサイトの監視登録を全て削除しました"
    redirect_to("/posts/index")
  end
  
  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

  def import

    # Post.import(params[:file])
    err_save_url=""
    err_access_url=""
    CSV.foreach(params[:file].path, headers: true, encoding: 'Shift_JIS:UTF-8') do |row|
      @post=Post.new(url: row['url'],
                  content: row['content'],
                  content2: row['content2'],
                  option: row['option'],
                  user_id: @current_user.id)

      if sitecheck(@post)

          if @post.save
            
          else
            err_save_url=err_save_url + @post.url + "\n"
          end

          # flash[:notice] = "監視サイト登録しました"
          # redirect_to("/posts/index")
        # else
        #   # render("posts/new")
        # end
      else
  
        err_access_url=err_access_url + @post.url + "\n"
        
        # redirect_to("/posts/index")
      end
      # post.attributes = row.to_hash.slice(*updatable_attributes)

      # post.save!
    end
    # 最終チェック
    if err_save_url == "" and err_access_url==""
      flash[:notice] = "登録完了しました"
      redirect_to("/posts/index")
    elsif err_access_url != ""
      flash[:notice] ="#{err_access_url}においてサイト読み込みエラー。登録できませんでした"
      render("posts/new")
    # elsif err_save_url <>"" and err_access_url ==""
    # elsif err_save_url =="" and err_access_url <> ""
    #   # flash[:notice] = 
    #   # redirect_to("/posts/index")
    #   errors.add(:post, "#{err_access_url}においてサイト読み込みエラー。登録できませんでした")
    # elsif err_save_url <>"" and err_access_url ==""
     else
      render("posts/new")
    # else
    #   errors.add(:post, "#{err_access_url}においてサイト読み込みエラー。登録できませんでした")
    end
    
    # else
    #   flash[:notice] = "#{err_url}においてサイト読み込みエラー。登録できませんでした"
    # end
    #  redirect_to("/posts/index")
  end

  def download
    download_file_name = "public/example.csv"
    send_file download_file_name
  end

  def convert(flag)
    if flag
      "あり"
    else
      "なし"
    end
  end

  helper_method :convert
  
end
