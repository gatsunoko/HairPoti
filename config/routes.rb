Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', confirmations: 'users/confirmations' }
  resources :pictures do
    collection do
      get :bulk_new
      post :bulk_create
      get :point_ranking
      get :win_ranking
      get :my_point_ranking
      get :my_histories
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homes#index'
  get 'homes/index'
  get 'homes/after_signup'
  get 'conflict/index'
  get 'conflict/elo'
  get 'conflict/img_blank'
end
