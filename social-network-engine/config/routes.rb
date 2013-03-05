Sne::Application.routes.draw do
  resources :posts, :only => [:index, :create]
  get 'context' => 'posts#post_context'

  # All facebook_tab_app actions just get forwarded
  match ':controller/:action', :controller => /facebook_tab_app/

  match '/search' => 'search#search'

  match '/refresh' => 'posts#refresh'

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }

  match 'main' => 'posts#index'
  root :to => 'posts#index'
end
