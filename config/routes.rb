Rails.application.routes.draw do
  resources :cargos
  resources :permissaos
  resources :perfils
  resources :users
  resources :funcionarios
  resources :sessao_caixas
  resources :ajuste_estoques
  resources :clientes
  resources :vendas
  resources :metodo_pagamentos
  resources :movimentacao_caixas
  resources :conta_recebers
  resources :conta_pagars
  resources :promocaos
  resources :item_pedido_compras
  resources :pedido_compras
  resources :fornecedors
  resources :lotes
  resources :produtos
  resources :categoria
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
