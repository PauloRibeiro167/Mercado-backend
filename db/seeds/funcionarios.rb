# Template genérico para seeds no projeto Mercadinho
# Este arquivo serve como base para criar novos arquivos de seeds.
# Substitua [NomeDoModelo] pelo nome do modelo (ex: Cargo, Produto).
# Substitua [itens] pelos dados a serem criados.
# Mantenha o padrão de formatação com rainbow para mensagens coloridas.

require 'rainbow'

# Seed para criar funcionários no projeto Mercadinho
puts Rainbow("Iniciando seed de funcionários...").blue

begin
  ActiveRecord::Base.transaction do
    puts Rainbow("Criando funcionários...").blue

    # Usar usuários existentes (assumindo que foram criados na seed de usuários)
    usuario_funcionario = Usuario.find_by!(email: 'funcionario@test.com')
    usuario_gerente = Usuario.find_by!(email: 'gerente@test.com')

    # Criar cargos necessários
    cargo_vendedor = Cargo.find_or_create_by!(nome: 'Vendedor')
    cargo_gerente = Cargo.find_or_create_by!(nome: 'Gerente')

    # Array de dados para criar
    itens = [
      {
        nome: 'Funcionário Exemplo',
        cpf: '123.456.789-00',
        telefone: '(11) 99999-0001',
        email: 'funcionario@test.com',
        data_nascimento: Date.new(1990, 1, 1),
        cargo: cargo_vendedor,
        salario: 2500.00,
        usuario: usuario_funcionario
      },
      {
        nome: 'Gerente Exemplo',
        cpf: '987.654.321-00',
        telefone: '(11) 99999-0002',
        email: 'gerente@test.com',
        data_nascimento: Date.new(1985, 5, 15),
        cargo: cargo_gerente,
        salario: 4000.00,
        usuario: usuario_gerente
      }
    ]

    # Contador de itens criados
    itens_criados = 0
    total_antes = Funcionario.count

    itens.each do |attrs|
      # Ajuste conforme o modelo: Funcionario.find_or_create_by!(nome: attrs[:nome]) do |f|
      #   f.assign_attributes(attrs)
      # end
      Funcionario.find_or_create_by!(nome: attrs[:nome]) do |f|
        f.assign_attributes(attrs)
      end
    end

    itens_criados = Funcionario.count - total_antes

    puts Rainbow("#{itens_criados} funcionário(s) criado(s) ou já existente(s).").green
    puts Rainbow("Seed de funcionários concluída com sucesso!").green.bold
  end
rescue ActiveRecord::Rollback => e
  puts Rainbow("Transação revertida devido a erros: #{e.message}").red
rescue StandardError => e
  puts Rainbow("Erro geral durante o processamento: #{e.message}").red
end