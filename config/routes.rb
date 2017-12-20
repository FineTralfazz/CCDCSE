Rails.application.routes.draw do
  root 'scoreboard#index'
  resources 'services'
end
