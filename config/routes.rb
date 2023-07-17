Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      get :vote_for, :vote_against
    end
  end

  resources :questions, concerns: %i[votable], shallow: true do
    resources :answers, only: %i[new create destroy update], concerns: %i[votable]
  end

  resources :files, only: :destroy
  resources :links, only: :destroy

  resources :users, only: :show

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
