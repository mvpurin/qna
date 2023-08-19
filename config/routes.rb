Rails.application.routes.draw do
  get 'comments/create'
  devise_for :users, controllers: { omniauth_collbacks: 'oauth_collbacks' }

  concern :votable do
    member do
      get :vote_for, :vote_against
    end
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :questions, concerns: %i[votable commentable], shallow: true do
    resources :answers, only: %i[new create destroy update], concerns: %i[votable commentable]
  end

  resources :files, only: :destroy
  resources :links, only: :destroy

  resources :users, only: :show

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
