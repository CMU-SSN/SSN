Sne::Application.routes.draw do
  resources :posts, :only => [:index, :create]

  get "facebook_tab_app/signup"
  get "facebook_tab_app/load_account"
  put "facebook_tab_app/create_account"
  get "facebook_tab_app/done"

  match '/search' => 'search#search'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  match 'main' => 'posts#index'
  root :to => 'posts#index'
end
