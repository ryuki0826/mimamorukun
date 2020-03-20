Rails.application.routes.draw do
  devise_for :users do
    #いらなそうなのでコメントアウトget '/users/sign_out' => 'devise/sessions#destroy'
  end
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # post "likes/:post_id/create" => "likes#create"
  # post "likes/:post_id/destroy" => "likes#destroy"

  #post "users/:id/update" => "users#update"#ユーザー情報変更実施
  #get "users/:id/edit" => "users#edit"#ユーザー情報変更画面
  # post "users/create" => "users#create"
  # get "signup" => "users#new"
  # get "users/index" => "users#index"
  get "users/upgrade" => "users#upgrade"#ユーザー情報画面
  get "users/:id" => "users#show"#ユーザー情報画面
 
  # post "login" => "users#login"
  # post "logout" => "users#logout"
  # get "login" => "users#login_form"
  # get "users/:id/likes" => "users#likes"
  
  #get "posts/scraping" => "posts#scraping"
  get "posts/index" => "posts#index"
  get "posts/new" => "posts#new"
  #get "posts/:id" => "posts#show"
  post "posts/create" => "posts#create"
  post "posts/destroyall" => "posts#destroyall"
  get "posts/:id/edit" => "posts#edit"
  post "posts/:id/update" => "posts#update"
  post "posts/:id/destroy" => "posts#destroy"

   #post で import 処理を許可する
   resources 'posts', only: :import do
    collection { post :import }
  end
  #ダウンロード
  get 'download', to: 'posts#download'




  get "/" => "home#top"
end
