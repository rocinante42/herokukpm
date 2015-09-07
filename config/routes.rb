Rails.application.routes.draw do

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
      get :download_report
    end
  end

  resources :triggers

  resources :edges

  resources :posets

  resources :bubble_groups

  resources :bubble_games

  resources :games

  resources :bubbles

  resources :users_admin, controller: 'users'

  resources :assignments do
    collection do
      get 'bulk_update'
      post 'bulk_submit'
    end
  end

  get 'dashboard' => 'home#dashboard'
  get 'activities' => 'home#activities'
  get 'report' => 'home#report'
  get 'choose_school' => 'home#choose_school'
  get 'set_school' => 'home#set_school'
  get 'teacher_mode' => 'home#teacher_mode'
  get 'dashboard_admin' => 'home#dashboard_admin'
  get 'dashboard_classroom' => 'home#dashboard_classroom'
  get 'new_user' => 'home#new_user' #obviously this should be removed
end
