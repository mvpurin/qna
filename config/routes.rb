Rails.application.routes.draw do
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, only: %i[new create destroy update]
  end

  resources :files

  root to: 'questions#index'
end
