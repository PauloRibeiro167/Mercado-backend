require 'rainbow'

# Seed para criar contas a pagar no projeto Mercadinho
puts Rainbow("Iniciando seed de contas a pagar...").blue

begin
  ActiveRecord::Base.transaction do
    puts Rainbow("Criando contas a pagar...").blue

    # Criar usuários necessários se não existirem
    usuario1 = Usuario.find_or_create_by!(email: 'usuario1@example.com') do |u|
      u.password = 'password123'
    end
    usuario2 = Usuario.find_or_create_by!(email: 'usuario2@example.com') do |u|
      u.password = 'password123'
    end

    # Criar fornecedores necessários
    fornecedor1 = Fornecedor.find_or_create_by!(nome: 'Fornecedor Exemplo') do |f|
      f.email = 'exemplo@fornecedor.com'
      f.usuario = usuario1
      f.responsavel = usuario1
    end
    fornecedor2 = Fornecedor.find_or_create_by!(nome: 'Outro Fornecedor') do |f|
      f.email = 'outro@fornecedor.com'
      f.usuario = usuario2
      f.responsavel = usuario2
    end

    # Criar pedidos de compra necessários
    pedido1 = PedidoCompra.find_or_create_by!(data: Date.today, fornecedor: fornecedor1)
    pedido2 = PedidoCompra.find_or_create_by!(data: Date.today, fornecedor: fornecedor2)

    # Array de dados para criar contas a pagar
    itens = [
      {
        fornecedor: fornecedor1,
        pedido_compra: pedido1,
        descricao: 'Pagamento de mercadorias',
        valor: 1500.50,
        data_vencimento: Date.today + 30,
        data_pagamento: nil,
        status: 'pendente'
      },
      {
        fornecedor: fornecedor2,
        pedido_compra: pedido2,
        descricao: 'Compra de equipamentos',
        valor: 2500.00,
        data_vencimento: Date.today + 15,
        data_pagamento: Date.today,
        status: 'pago'
      }
    ]

    # Contador de itens criados
    itens_criados = 0
    total_antes = ContaPagar.count

    itens.each do |attrs|
      # Ajuste conforme o modelo: ContaPagar.create!(attrs)
      ContaPagar.create!(attrs)
    end

    itens_criados = ContaPagar.count - total_antes

    puts Rainbow("#{itens_criados} conta(s) a pagar criada(s).").green
    puts Rainbow("Seed de contas a pagar concluída com sucesso!").green.bold
  end
rescue ActiveRecord::Rollback => e
  puts Rainbow("Transação revertida devido a erros: #{e.message}").red
rescue StandardError => e
  puts Rainbow("Erro geral durante o processamento: #{e.message}").red
end
