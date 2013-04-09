Sne::Application.routes.draw do
  resources :posts, :only => [:index, :new, :create]
	resources :organizations, :only =>[:show]
	get 'context' => 'posts#post_context'
  get 'checkin' => 'posts#checkin'
  get 'signup' => 'facebook_tab_app#signup'
  get 'location' => 'posts#where_am_i'

  # All facebook_tab_app actions just get forwarded
  match ':controller/:action', :controller => /facebook_tab_app/

  match '/search' => 'search#search'

  match '/refresh' => 'posts#refresh'

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }

  match 'main' => 'posts#index'
  root :to => 'posts#index'
	resources :users, :only=>[:show]
end
