Rails.application.routes.draw do
  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'admin' && password == ENV['CCDCSE_ADMIN_PASS']
  end
  mount Sidekiq::Web => '/sidekiq'

  get '/logout', to: 'auth#logout'

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

  scope :admin do
    get '/', to: 'admin#index'
    post 'reset_points', to: 'admin#reset_points'
    post 'game_status', to: 'admin#game_status'
  end
end