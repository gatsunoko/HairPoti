Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations',
                                    confirmations: 'users/confirmations',
                                    sessions: "users/sessions",
                                    omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, :only => [:index, :show] do
    member do
      get :password_edit
      patch :password_update
    end
  end
  
  resources :pictures do
    collection do
      get :short_ranking
      get :midiamu_ranking
      get :long_ranking
      get :my_histories
      get :multiple_url
      get :search
      get :prev_add
      get :next_add
    end
    member do
      get :show_modal
    end
  end

  resources :follows, only: [:index] do
    member do
      get :follow
      get :stop_follow
      get :followers
      get :follows
    end
  end

  namespace 'admin' do
    get 'administrator/index'
    get 'administrator/blank_pictures'
    get 'administrator/image_present'
    delete 'administrator/bulk_destroy'
  end

  resources :stylists, only: [:edit, :update]
  
  root 'homes#index'
  get 'homes/index'
  get 'homes/follows'
  get 'homes/after_signup'
  get 'conflict/index'
  get 'conflict/elo'
  get 'conflict/img_blank'
  get 'conflict/result'
  get 'likes/like'
  get 'likes/likes'
  get 'likes/persons'

  get 'search/index'
  get 'search/prefecture_change'
end
