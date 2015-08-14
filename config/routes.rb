Rails.application.routes.draw do

  authenticated :user do
    root :to => 'home#dashboard', as: :authenticated_root
  end
  root to: 'home#index'
  get 'home/index'

  devise_for :users, controllers: { registrations: "registrations" }
  resources :roles




  resources :bubble_categories

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
      get :reports
      get :play
      get :play_game
      get :games
      post :result
    end
  end

  resources :triggers

  resources :edges

  resources :posets

  resources :bubble_groups

  resources :bubble_games

  resources :games

  resources :bubbles

  get 'dashboard' => 'home#dashboard'
  get 'activities' => 'home#activities'
  get 'report' => 'home#report'
end
