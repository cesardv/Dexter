Dexter::Application.routes.draw do
  resources :drops
  match '/drops/:id', :constraints => {:id => /.*/}, :controller => :drops, :action => :show

  root :to => 'drops#show', :id => 'root'

  match '/:id', :constraints => {:id => /.*/}, :controller => :dispatches, :action => :show
end
