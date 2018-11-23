Stripes::Engine.routes.draw do
  resources :hooks, only: :create
end
