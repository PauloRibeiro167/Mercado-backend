# Este arquivo deve garantir a existência dos registros necessários para executar a aplicação em todos os ambientes (produção,
# desenvolvimento, teste). O código aqui deve ser idempotente, de modo que possa ser executado a qualquer momento em qualquer ambiente.
# Os dados podem então ser carregados com o comando bin/rails db:seed (ou criados junto com o banco de dados usando db:setup).

# Carregar seeds individuais
load Rails.root.join('db/seeds/usuarios.rb') # feito 
load Rails.root.join('db/seeds/cargos.rb') #feito
load Rails.root.join('db/seeds/funcionarios.rb')
load Rails.root.join('db/seeds/perfils.rb')
load Rails.root.join('db/seeds/permissaos.rb')
load Rails.root.join('db/seeds/categoria.rb')
load Rails.root.join('db/seeds/perfil_permissaos.rb')
load Rails.root.join('db/seeds/usuario_perfils.rb')
load Rails.root.join('db/seeds/fornecedors.rb')
load Rails.root.join('db/seeds/lotes.rb')
load Rails.root.join('db/seeds/pedido_compras.rb')
load Rails.root.join('db/seeds/item_pedido_compras.rb')
load Rails.root.join('db/seeds/promocaos.rb')
load Rails.root.join('db/seeds/conta_pagars.rb')
load Rails.root.join('db/seeds/conta_recebers.rb')
load Rails.root.join('db/seeds/movimentacao_caixas.rb')
load Rails.root.join('db/seeds/metodo_pagamentos.rb')
load Rails.root.join('db/seeds/vendas.rb')
load Rails.root.join('db/seeds/item_vendas.rb')
load Rails.root.join('db/seeds/clientes.rb')
load Rails.root.join('db/seeds/ajuste_estoques.rb')
load Rails.root.join('db/seeds/sessao_caixas.rb')
load Rails.root.join('db/seeds/produto_fornecedors.rb')
