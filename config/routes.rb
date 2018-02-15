Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', confirmations: 'users/confirmations' }
  resources :pictures do
    collection do
      get :collect_new
      post :collect_call
      get :short_ranking
      get :midiamu_ranking
      get :long_ranking
      get :my_histories
      get :blank_pictures
      get :length_blanks
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
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
