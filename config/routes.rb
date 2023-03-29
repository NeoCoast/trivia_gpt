Rails.application.routes.draw do
  devise_for :users

  root to: 'rounds#index'

  resources :rounds do
    post :end_round
    post :add_question

    resources :questions do
      patch 'answer', on: :member
    end
  end
end
