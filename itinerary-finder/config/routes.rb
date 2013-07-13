ItineraryFinder::Application.routes.draw do

  resources :arcs


  resources :nodes


  resources :train_routes


  resources :trains

  root      :to             => "home#index"

end
