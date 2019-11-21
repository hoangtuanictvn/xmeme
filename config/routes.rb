Rails.application.routes.draw do
  root to: "pages#index", page: :home
  get :privacy, to: "pages#index", page: :privacy

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"
  post :logout, to: "sessions#destroy"
  
end
