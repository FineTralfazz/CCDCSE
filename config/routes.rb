Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'admin' && password == ENV['CCDCSE_ADMIN_PASSWORD']
  end
  mount Sidekiq::Web => '/sidekiq'

  get '/logout', to: 'auth#logout'

  root 'scoreboard#index'
  scope :scoreboard do
    get '/', to: 'scoreboard#index'
    get 'last_check', to: 'scoreboard#last_check'
    get 'as_json', to: 'scoreboard#as_json'
    get ':team_id', to: 'scoreboard#show'
  end

  resources 'services'

  resources 'teams'

  scope :users do
    get '/', to: 'users#index'
    get 'upload/:team_id', to: 'users#upload'
    post 'upload/:team_id', to: 'users#upload'
  end

  scope :admin do
    get '/', to: 'admin#index'
    post 'reset_points', to: 'admin#reset_points'
    post 'toggle_scoring', to: 'admin#toggle_scoring'
    post 'score_all', to: 'admin#score_all'
  end
end