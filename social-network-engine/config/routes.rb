Sne::Application.routes.draw do
  resources :posts


  get "facebook_tab_app/signup"
  get "facebook_tab_app/load_account"
  put "facebook_tab_app/create_account"
  get "facebook_tab_app/done"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  match 'login' => 'mobile_pages#login'
  match 'main' => 'posts#index'
  root :to => 'mobile_pages#login'
end
