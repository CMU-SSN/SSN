Sne::Application.routes.draw do
  match 'login' => 'mobile_pages#login'
  match 'main' => 'mobile_pages#main'
  root :to => 'mobile_pages#login'
end
