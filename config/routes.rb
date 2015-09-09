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

  resources :users_admin, controller: 'users' do
    collection do
     # get :dashboard
     # get :dashboard_admin
    end
  end


  resources :assignments do
    collection do
      get 'bulk_update'
      post 'bulk_submit'
    end
  end

  get 'dashboard' => 'users#dashboard'
  get 'activities' => 'users#activities'
  get 'report' => 'home#report'
  get 'choose_school' => 'home#choose_school'
  get 'set_school' => 'home#set_school'
  get 'teacher_mode' => 'users#teacher_mode'
  get 'dashboard_admin' => 'users#dashboard_admin'
  get 'dashboard_classroom' => 'users#dashboard_classroom'

  namespace :api do
    resources :kids
    resources :posets
    resources :bubble_groups
    resources :bubble_games
    resources :games
    resources :bubbles
    resources :bubble_statuses
    resources :schools
    resources :classrooms
  end
>>>>>>> #67 :: part of API
end
