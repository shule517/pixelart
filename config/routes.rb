Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
  get ':screen_name', to: 'artists#show', as: :artist
  resources :hashtags, only: %i(show)
end
