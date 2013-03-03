Sne::Application.routes.draw do
  resources :posts, :only => [:index, :create]

  # All facebook_tab_app actions just get forwarded
  match ':controller/:action', :controller => /facebook_tab_app/

  match '/search' => 'search#search'

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }

  match 'main' => 'posts#index'
  root :to => 'posts#index'
end
