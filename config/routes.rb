Rails.application.routes.draw do
  resources :audit_logs
  resources :system_settings
  resources :dashboard_widgets
  resources :dashboards
  resources :ai_interaction_logs
  resources :ai_suggestions
  resources :notifications
  resources :alerts
  resources :alert_rules
  resources :run_logs
  resources :pipeline_step_runs
  resources :pipeline_runs
  resources :schedules
  resources :pipeline_steps
  resources :pipelines
  resources :connections
  resources :projects
  resources :messages
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Demo route
  get "demo" => "home#demo"

  # Docs route
  get "docs" => "home#docs"

  # Defines the root path route ("/")
  root "home#index"
end
