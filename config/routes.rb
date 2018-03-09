Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', confirmations: 'users/confirmations', sessions: "users/sessions" }
  resources :pictures do
    collection do
      get :bulk_new
      post :bulk_create
      get :short_ranking
      get :midiamu_ranking
      get :long_ranking
      get :my_histories
      get :multiple_url
      get :search
      get :next_picture
      get :prev_add
      get :next_add
    end
    member do
      get :show_modal
    end
  end

  namespace 'admin' do
    get 'administrator/index'
    get 'administrator/blank_pictures'
    get 'administrator/multiple_urls'
    get 'administrator/multiple_url'
    get 'administrator/image_present'
    delete 'administrator/bulk_destroy'
  end

  resources :stylists, only: [:edit, :update]
  root 'homes#index'
  get 'homes/index'
  get 'homes/after_signup'
  get 'conflict/index'
  get 'conflict/elo'
  get 'conflict/img_blank'
  get 'conflict/result'
  get 'likes/like'
  get 'likes/likes'
end
