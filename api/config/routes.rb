Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  root to: redirect("/api/v1/status")

  namespace :api do
    namespace :v1 do
      get "status", to: "status#index"

      # 1. Autenticação (Isolado em seu próprio namespace)
      namespace :autenticacao do
        post "login",   to: "sessoes#create"
        post "refresh", to: "sessoes#refresh"
      end

      # 2. Administração
      namespace :admin do
        resources :usuarios
        resources :permissaos
        resources :perfils
        resources :tipos_contratos
      end

      # 3. Recursos Humanos
      namespace :rh do
        resources :funcionarios
        resources :cargos
        resources :registro_pontos
        resources :horario_funcionamentos
      end

      # 4. PDV / Frente de Caixa
      namespace :pdv do
        resources :caixas
        resources :sessao_caixas
        resources :vendas
        resources :item_vendas
        resources :clientes
        resources :metodo_pagamentos
        resources :promocaos
        resources :movimentacao_caixas
      end

      # 5. Estoque e Suprimentos
      namespace :estoque do
        resources :produtos
        resources :categoria
        resources :estoques
        resources :ajuste_estoques
        resources :lotes
        resources :fornecedors do
          member { get :produtos }
        end
        resources :produto_fornecedors
        resources :pedido_compras
        resources :item_pedido_compras
      end

      # 6. Financeiro
      namespace :financeiro do
        resources :conta_recebers
        resources :conta_pagars
        resources :parcelas_conta_pagars
        resources :pagamentos
        resources :caixa_reconciliacaos
      end
    end
  end

  match "*unmatched", to: "application#route_not_found", via: :all
end
