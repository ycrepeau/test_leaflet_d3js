Rails.application.routes.draw do
  get 'laurier_dorion/index'

  get 'gouin/index'

  get 'mercier/index'

  get 'sainte_marie_saint_jacques/index'

  get 'ho_ma/index'

  get 'rosemont/index'

  get 'bonjour/index'
  get 'locations/render/:size' => 'locations#render_size'
  root 'bonjour#index'
  resources :locations

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
