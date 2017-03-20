Rails.application.routes.draw do
  get 'bonjour/index'
  get 'locations/render/:size' => 'locations#render_size'
  root 'bonjour#index'
  resources :locations

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
