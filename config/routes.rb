require 'sidekiq/web'

Rails.application.routes.draw do
  get 'search' => 'searches#search'
  
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  get 'comments/create'
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', confirmations: 'user/confirmations' }

  concern :votable do
    member do
      get :vote_for, :vote_against
    end
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resource :email_confirmation, only: %i[new create]

  resources :questions, concerns: %i[votable commentable], shallow: true do
    resources :answers, only: %i[new create destroy update], concerns: %i[votable commentable]
    get :subscribe, on: :member
  end

  resources :files, only: :destroy
  resources :links, only: :destroy

  resources :users, only: [:show, :edit, :update] do
    # get :settings, on: :member
    # post :settings, on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :all, on: :collection
      end

      resources :questions, only: [:index, :show, :destroy, :create, :update], shallow: true do
        resources :answers, only: [:index, :show, :destroy, :create, :update]
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
