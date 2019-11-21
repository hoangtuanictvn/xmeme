Rails.application.routes.draw do
  root to: "pages#index", page: :home
  get :privacy, to: "pages#index", page: :privacy
end
