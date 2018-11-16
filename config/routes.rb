Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'scoreboard#index'
  scope :scoreboard do
    get '/', to: 'scoreboard#index'
    get 'last_check', to: 'scoreboard#last_check'
    get ':team_id', to: 'scoreboard#show'
  end

  get 'services/score_all', 'services#score_all'
  resources 'services'

  scope :users do
    get '/', to: 'users#index'
    get 'upload/:team_id', to: 'users#upload'
    post 'upload/:team_id', to: 'users#upload'
  end
end