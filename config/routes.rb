Rails.application.routes.draw do
  root 'scoreboard#index'
  get 'services/score_all', 'services#score_all'
  resources 'services'
  get 'users', to: 'users#index'
  get 'users/upload/:team', to: 'users#upload'
  post 'users/upload/:team', to: 'users#upload'
end