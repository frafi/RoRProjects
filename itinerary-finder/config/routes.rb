ItineraryFinder::Application.routes.draw do

  resources :node_details


  resources :arcs

  resources :nodes

  resources :train_routes

  resources :trains
  
  get       'calculate',        :to => "home#show_itinerary"

  root      :to => "home#index"

end
