ItineraryFinder::Application.routes.draw do

  resources :arcs

  resources :nodes

  resources :train_routes

  resources :trains
  
  get       'calculate',        :to => "home#show_itinerary"

  root      :to => "home#index"

end
