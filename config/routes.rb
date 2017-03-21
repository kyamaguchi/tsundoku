Rails.application.routes.draw do
  root to: 'books#index'
  resources :books, only: [:index] do
    collection do
      get :search
      put :mark_as_read
    end
  end
end
