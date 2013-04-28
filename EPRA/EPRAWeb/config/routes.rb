EPRAWeb::Application.routes.draw do
  # ** Patients **
  # ---View---
  match '/patients', :to => 'persons#show_all'
  match '/patients/:id/', :to => 'persons#show_all'
  match '/mypatients', :to => 'persons#show_assigned'
  match '/activepatients', :to => 'persons#show_active'
  # ---Edit---
  match '/add', :to => 'persons#show_all'
  # ** End of patients **

  # Claims
  match '/claims', :to => 'contracts#show_all'
  match '/claims', :to => 'contracts#show_all'
  # Encounters
  # Diets
  # Contracts
end
