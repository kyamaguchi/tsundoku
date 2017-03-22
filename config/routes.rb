Rails.application.routes.draw do
  get 'dashboard/index'

  resources :books, only: [:index] do
    collection do
      get :search
      put :mark_as_read
    end
  end

  root to: 'dashboard#index'
end
