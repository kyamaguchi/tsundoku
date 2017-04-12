Rails.application.routes.draw do
  get 'dashboard/index'

  resources :books, only: [:index] do
    collection do
      get :data
      put :update_selected
    end
  end
  resources :authors, only: [:index]

  root to: 'dashboard#index'
end
