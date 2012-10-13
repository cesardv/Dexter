Dexter::Application.routes.draw do
  resources :drops
  root :to => 'drops#new'
end
