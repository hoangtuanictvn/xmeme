Rails.application.routes.draw do
  root to: "pages#index", page: :home
  get :privacy, to: "pages#index", page: :privacy

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"
  delete :logout, to: "sessions#destroy"
  get :layouts, to: "card_layouts#index"
  post "layout/change", to: "card_layouts#change"
  post :add, to: "resources#add"
  get :upload, to: "upload#index"
  delete :drop_resource, to: "upload#drop_resource"
  
  resources :shares do
    get :story
  end

  resources :cards do
    post :generate
    post :detach_music
  end

  resources :resources do
    post :upload, on: :collection
    post :load, on: :collection
    post :insert, on: :collection
  end
end
