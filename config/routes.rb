Rails.application.routes.draw do
  resources :bubble_group_statuses do
    member do
      get :reset
    end
  end

  resources :bubble_statuses

  resources :schools

  resources :classrooms do
    member do
      post :activate
    end
  end

  resources :kids do
    member do
      get :play
      get :play_game
      get :games
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

