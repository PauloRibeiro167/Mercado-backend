# Este arquivo deve garantir a existência dos registros necessários para executar a aplicação em todos os ambientes (produção,
# desenvolvimento, teste). O código aqui deve ser idempotente, de modo que possa ser executado a qualquer momento em qualquer ambiente.
# Os dados podem então ser carregados com o comando bin/rails db:seed (ou criados junto com o banco de dados usando db:setup).

# Carregar seeds individuais na ordem das migrations
load Rails.root.join('db/seeds/role.rb') # CreateRoles
load Rails.root.join('db/seeds/usuarios.rb') # CreateUsuarios
load Rails.root.join('db/seeds/cargos.rb') # CreateCargos
load Rails.root.join('db/seeds/tipos_contrato.rb') # CreateTiposContrato
load Rails.root.join('db/seeds/funcionarios.rb') # CreateFuncionarios
load Rails.root.join('db/seeds/perfils.rb') # CreatePerfils
load Rails.root.join('db/seeds/permissaos.rb') # CreatePermissaos
load Rails.root.join('db/seeds/perfil_permissaos.rb') # CreatePerfilPermissaos
load Rails.root.join('db/seeds/categoria.rb') # CreateCategoria
load Rails.root.join('db/seeds/usuario_perfils.rb') # CreateUsuarioPerfils
load Rails.root.join('db/seeds/produtos.rb') # CreateProdutos
load Rails.root.join('db/seeds/fornecedors.rb') # reateFornecedors
load Rails.root.join('db/seeds/lotes.rb') # CreateLotes
load Rails.root.join('db/seeds/pedido_compras.rb') # CreatePedidoCompras
load Rails.root.join('db/seeds/item_pedido_compras.rb') # CreateItemPedidoCompras
load Rails.root.join('db/seeds/promocaos.rb') # CreatePromocaos
load Rails.root.join('db/seeds/metodo_pagamentos.rb') # CreateMetodoPagamentos
load Rails.root.join('db/seeds/conta_pagars.rb') # CreateContaPagars
load Rails.root.join('db/seeds/parcelas_contas_pagar.rb') # CreateParcelasContaPagars
load Rails.root.join('db/seeds/conta_recebers.rb') # CreateContaRecebers
load Rails.root.join('db/seeds/pagamentos.rb') # CreatePagamentos
load Rails.root.join('db/seeds/estoque.rb') # CreateEstoques
load Rails.root.join('db/seeds/caixas.rb') # CreateCaixas
load Rails.root.join('db/seeds/sessao_caixas.rb') # CreateSessaoCaixas
load Rails.root.join('db/seeds/movimentacao_caixas.rb') # CreateMovimentacaoCaixas
load Rails.root.join('db/seeds/caixa_reconciliacoes.rb') # CreateCaixaReconciliacoes
load Rails.root.join('db/seeds/metodo_pagamentos.rb') # CreateMetodoPagamentos
load Rails.root.join('db/seeds/vendas.rb') # CreateVendas
load Rails.root.join('db/seeds/item_vendas.rb') # CreateItemVendas
load Rails.root.join('db/seeds/clientes.rb') # CreateClientes
load Rails.root.join('db/seeds/ajuste_estoques.rb') # CreateAjusteEstoques
load Rails.root.join('db/seeds/produto_fornecedors.rb') # CreateProdutoFornecedors
load Rails.root.join('db/seeds/horarios_funcionamento.rb') # CreateHorariosFuncionamento
load Rails.root.join('db/seeds/folha_pagamentos.rb') # CreateFolhaPagamentos
load Rails.root.join('db/seeds/registro_pontos.rb') # CreateRegistroPontos
