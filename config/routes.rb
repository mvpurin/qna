Rails.application.routes.draw do
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, only: %i[new create destroy update]
  end

  resources :files, only: :destroy
  resources :links, only: :destroy

  # resources :users do
  #   get 'rewards', on: :member
  # end

  resources :users, only: :show

  root to: 'questions#index'
end
