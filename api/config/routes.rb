Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # opcional: root redireciona para status da API v1
  root to: redirect("/api/v1/status")

  namespace :api do
    namespace :v1 do
      resources :caixa_reconciliacaos
      get "status", to: "status#index"

      post "auth/login",   to: "auth#login"
      post "auth/refresh", to: "auth#refresh"

      resources :pagamentos
      resources :produto_fornecedors
      resources :caixas
      resources :estoques
      resources :tipos_contratos
      resources :horario_funcionamentos
      resources :registro_pontos
      resources :cargos
      resources :permissaos
      resources :perfils
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
      resources :item_vendas
      resources :pedido_compras
      resources :fornecedors do
        member { get :produtos }
      end
      resources :lotes
      resources :produtos
      resources :categoria
      resources :usuarios
    end
  end

  match "*unmatched", to: "application#route_not_found", via: :all
end
