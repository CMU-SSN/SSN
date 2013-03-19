Sne::Application.routes.draw do
  resources :posts, :only => [:index, :new, :create]
  get 'context' => 'posts#post_context'
  get 'checkin' => 'posts#checkin'
  get 'signup' => 'facebook_tab_app#signup'

  # All facebook_tab_app actions just get forwarded
  match ':controller/:action', :controller => /facebook_tab_app/

  match '/search' => 'search#search'

  match '/refresh' => 'posts#refresh'

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }

  match 'main' => 'posts#index'
  root :to => 'posts#index'
end
