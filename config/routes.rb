Rails.application.routes.draw do
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, only: %i[new create destroy update]
  end

  resources :files, only: :destroy
  resources :links, only: :destroy

  resources :users, only: :show

  get '/vote/:id', to: 'questions#vote', as: 'vote'

  root to: 'questions#index'
end
