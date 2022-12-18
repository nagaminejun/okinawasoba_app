Rails.application.routes.draw do

  root 'home#top'
  get 'about', to: 'home#about'
  get '/signup', to: 'users#new'
  get '/posts/index', to: 'posts#index' # 全投稿一覧ページ
  
  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get 'line_login_api/login', to: 'line_login_api#login'
  get 'line_login_api/callback', to: 'line_login_api#callback'
  get 'line_login_api/new', to: 'line_login_api#new'
  get 'line_login_api/create', to: 'line_login_api#create'
  
  resources :users do
    resources :posts
  end
end