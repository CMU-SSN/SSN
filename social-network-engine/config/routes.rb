Sne::Application.routes.draw do
  get "facebook_tap_app/main"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  match 'login' => 'mobile_pages#login'
  match 'main' => 'mobile_pages#main'
  root :to => 'mobile_pages#login'
end
