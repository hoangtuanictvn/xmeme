Rails.application.routes.draw do
  root to: "pages#index", page: :home
  get :privacy, to: "pages#index", page: :privacy

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"
  delete :logout, to: "sessions#destroy"
  get :layouts, to: "card_layouts#index"
  post :add,  to: "resources#add"

  resources :cards
end
