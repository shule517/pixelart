require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
  get ':lang', to: 'home#index', constraints: { lang: /ja|en/ }
  resources :hashtags, only: %i(index show)
  mount Sidekiq::Web => '/sidekiq'
  get ':screen_name', to: 'artists#show', as: :artist
end
