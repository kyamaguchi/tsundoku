Rails.application.routes.draw do
  resources :books, only: [:index] do
    collection do
      get :search
    end
  end
end
