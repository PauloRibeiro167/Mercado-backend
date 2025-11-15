# Criar permissões de acesso para o sistema
permissaos = [
  # Usuários
  { nome: 'Criar Usuário', chave_acao: 'users.create' },
  { nome: 'Visualizar Usuários', chave_acao: 'users.read' },
  { nome: 'Editar Usuário', chave_acao: 'users.update' },
  { nome: 'Excluir Usuário', chave_acao: 'users.delete' },

  # Perfis
  { nome: 'Criar Perfil', chave_acao: 'perfis.create' },
  { nome: 'Visualizar Perfis', chave_acao: 'perfis.read' },
  { nome: 'Editar Perfil', chave_acao: 'perfis.update' },
  { nome: 'Excluir Perfil', chave_acao: 'perfis.delete' },

  # Permissões
  { nome: 'Criar Permissão', chave_acao: 'permissaos.create' },
  { nome: 'Visualizar Permissões', chave_acao: 'permissaos.read' },
  { nome: 'Editar Permissão', chave_acao: 'permissaos.update' },
  { nome: 'Excluir Permissão', chave_acao: 'permissaos.delete' },

  # Produtos
  { nome: 'Criar Produto', chave_acao: 'produtos.create' },
  { nome: 'Visualizar Produtos', chave_acao: 'produtos.read' },
  { nome: 'Editar Produto', chave_acao: 'produtos.update' },
  { nome: 'Excluir Produto', chave_acao: 'produtos.delete' },

  # Categorias
  { nome: 'Criar Categoria', chave_acao: 'categorias.create' },
  { nome: 'Visualizar Categorias', chave_acao: 'categorias.read' },
  { nome: 'Editar Categoria', chave_acao: 'categorias.update' },
  { nome: 'Excluir Categoria', chave_acao: 'categorias.delete' },

  # Lotes/Estoque
  { nome: 'Criar Lote', chave_acao: 'lotes.create' },
  { nome: 'Visualizar Lotes', chave_acao: 'lotes.read' },
  { nome: 'Editar Lote', chave_acao: 'lotes.update' },
  { nome: 'Excluir Lote', chave_acao: 'lotes.delete' },

  # Fornecedores
  { nome: 'Criar Fornecedor', chave_acao: 'fornecedors.create' },
  { nome: 'Visualizar Fornecedores', chave_acao: 'fornecedors.read' },
  { nome: 'Editar Fornecedor', chave_acao: 'fornecedors.update' },
  { nome: 'Excluir Fornecedor', chave_acao: 'fornecedors.delete' },

  # Pedidos de Compra
  { nome: 'Criar Pedido de Compra', chave_acao: 'pedido_compras.create' },
  { nome: 'Visualizar Pedidos de Compra', chave_acao: 'pedido_compras.read' },
  { nome: 'Editar Pedido de Compra', chave_acao: 'pedido_compras.update' },
  { nome: 'Excluir Pedido de Compra', chave_acao: 'pedido_compras.delete' },

  # Vendas
  { nome: 'Criar Venda', chave_acao: 'vendas.create' },
  { nome: 'Visualizar Vendas', chave_acao: 'vendas.read' },
  { nome: 'Editar Venda', chave_acao: 'vendas.update' },
  { nome: 'Excluir Venda', chave_acao: 'vendas.delete' },

  # Clientes
  { nome: 'Criar Cliente', chave_acao: 'clientes.create' },
  { nome: 'Visualizar Clientes', chave_acao: 'clientes.read' },
  { nome: 'Editar Cliente', chave_acao: 'clientes.update' },
  { nome: 'Excluir Cliente', chave_acao: 'clientes.delete' },

  # Funcionários
  { nome: 'Criar Funcionário', chave_acao: 'funcionarios.create' },
  { nome: 'Visualizar Funcionários', chave_acao: 'funcionarios.read' },
  { nome: 'Editar Funcionário', chave_acao: 'funcionarios.update' },
  { nome: 'Excluir Funcionário', chave_acao: 'funcionarios.delete' },

  # Cargos
  { nome: 'Criar Cargo', chave_acao: 'cargos.create' },
  { nome: 'Visualizar Cargos', chave_acao: 'cargos.read' },
  { nome: 'Editar Cargo', chave_acao: 'cargos.update' },
  { nome: 'Excluir Cargo', chave_acao: 'cargos.delete' },

  # Métodos de Pagamento
  { nome: 'Criar Método de Pagamento', chave_acao: 'metodo_pagamentos.create' },
  { nome: 'Visualizar Métodos de Pagamento', chave_acao: 'metodo_pagamentos.read' },
  { nome: 'Editar Método de Pagamento', chave_acao: 'metodo_pagamentos.update' },
  { nome: 'Excluir Método de Pagamento', chave_acao: 'metodo_pagamentos.delete' },

  # Promoções
  { nome: 'Criar Promoção', chave_acao: 'promocaos.create' },
  { nome: 'Visualizar Promoções', chave_acao: 'promocaos.read' },
  { nome: 'Editar Promoção', chave_acao: 'promocaos.update' },
  { nome: 'Excluir Promoção', chave_acao: 'promocaos.delete' },

  # Ajustes de Estoque
  { nome: 'Criar Ajuste de Estoque', chave_acao: 'ajuste_estoques.create' },
  { nome: 'Visualizar Ajustes de Estoque', chave_acao: 'ajuste_estoques.read' },
  { nome: 'Editar Ajuste de Estoque', chave_acao: 'ajuste_estoques.update' },
  { nome: 'Excluir Ajuste de Estoque', chave_acao: 'ajuste_estoques.delete' },

  # Sessões de Caixa
  { nome: 'Criar Sessão de Caixa', chave_acao: 'sessao_caixas.create' },
  { nome: 'Visualizar Sessões de Caixa', chave_acao: 'sessao_caixas.read' },
  { nome: 'Editar Sessão de Caixa', chave_acao: 'sessao_caixas.update' },
  { nome: 'Excluir Sessão de Caixa', chave_acao: 'sessao_caixas.delete' },

  # Movimentações de Caixa
  { nome: 'Criar Movimentação de Caixa', chave_acao: 'movimentacao_caixas.create' },
  { nome: 'Visualizar Movimentações de Caixa', chave_acao: 'movimentacao_caixas.read' },
  { nome: 'Editar Movimentação de Caixa', chave_acao: 'movimentacao_caixas.update' },
  { nome: 'Excluir Movimentação de Caixa', chave_acao: 'movimentacao_caixas.delete' },

  # Contas a Pagar
  { nome: 'Criar Conta a Pagar', chave_acao: 'conta_pagars.create' },
  { nome: 'Visualizar Contas a Pagar', chave_acao: 'conta_pagars.read' },
  { nome: 'Editar Conta a Pagar', chave_acao: 'conta_pagars.update' },
  { nome: 'Excluir Conta a Pagar', chave_acao: 'conta_pagars.delete' },

  # Contas a Receber
  { nome: 'Criar Conta a Receber', chave_acao: 'conta_recebers.create' },
  { nome: 'Visualizar Contas a Receber', chave_acao: 'conta_recebers.read' },
  { nome: 'Editar Conta a Receber', chave_acao: 'conta_recebers.update' },
  { nome: 'Excluir Conta a Receber', chave_acao: 'conta_recebers.delete' },

  # Relatórios
  { nome: 'Visualizar Relatórios de Vendas', chave_acao: 'relatorios.vendas.read' },
  { nome: 'Visualizar Relatórios de Estoque', chave_acao: 'relatorios.estoque.read' },
  { nome: 'Visualizar Relatórios Financeiros', chave_acao: 'relatorios.financeiros.read' },
  { nome: 'Visualizar Relatórios de Produtos', chave_acao: 'relatorios.produtos.read' },

  # Configurações do Sistema
  { nome: 'Editar Configurações do Sistema', chave_acao: 'configuracoes.update' },
  { nome: 'Visualizar Configurações do Sistema', chave_acao: 'configuracoes.read' }
]

permissaos.each do |permissao_attrs|
  Permissao.find_or_create_by!(chave_acao: permissao_attrs[:chave_acao]) do |permissao|
    permissao.nome = permissao_attrs[:nome]
  end
end