Rails.application.routes.draw do
  root 'home#index'
  get 'proxy' => 'proxy#index'
  resources :users, only: [:index, :show]
end
