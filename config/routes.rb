Rails.application.routes.draw do
  devise_for :users
  resources :pictures do
    collection do
      get :bulk_new
      post :bulk_create
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homes#index'
  get 'homes/index'
  get 'conflict/index'
  get 'conflict/elo'
end
