Rails.application.routes.draw do
  resources :bubble_group_statuses

  resources :bubble_statuses

  resources :schools

  resources :classrooms

  resources :kids do
    member do
      get :play
    end
  end

  resources :triggers

  resources :edges

  resources :posets

  resources :bubble_groups

  resources :bubble_games

  resources :games

  resources :bubbles

  root to: 'home#index'
  get 'home/index'
end

