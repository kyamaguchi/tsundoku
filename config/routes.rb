Rails.application.routes.draw do
  get 'dashboard/index'

  resources :books, only: [:index] do
    collection do
      put :mark_as_read
    end
  end
  resources :authors, only: [:index]
  resources :tags, only: [:index] do
    collection do
      get :summary
      put :apply_to_books
    end
  end

  root to: 'dashboard#index'
end
