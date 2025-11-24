# Template genérico para seeds no projeto Mercadinho
# Este arquivo serve como base para criar novos arquivos de seeds.
# Substitua [NomeDoModelo] pelo nome do modelo (ex: Cargo, Produto).
# Substitua [itens] pelos dados a serem criados.
# Mantenha o padrão de formatação com rainbow para mensagens coloridas.

require 'rainbow'

# Função para gerar CPF válido fake
def generate_valid_cpf
  digits = 9.times.map { rand(10) }

  # Calcula primeiro dígito verificador
  sum = 0
  9.times { |i| sum += digits[i] * (10 - i) }
  first_verifier = (sum * 10) % 11
  first_verifier = 0 if first_verifier == 10
  digits << first_verifier

  # Calcula segundo dígito verificador
  sum = 0
  10.times { |i| sum += digits[i] * (11 - i) }
  second_verifier = (sum * 10) % 11
  second_verifier = 0 if second_verifier == 10
  digits << second_verifier

  # Formata como string
  "#{digits[0..2].join}.#{digits[3..5].join}.#{digits[6..8].join}-#{digits[9]}#{digits[10]}"
end

# Seeds para clientes
puts Rainbow("Iniciando seed de clientes...").blue

begin
  ActiveRecord::Base.transaction do
    puts Rainbow("Criando clientes...").blue

    # Array de dados para criar
    itens = [
      { nome: 'João Silva', cpf: generate_valid_cpf, telefone: '(11) 99999-0001', email: 'joao.silva@email.com' },
      { nome: 'Maria Oliveira', cpf: generate_valid_cpf, telefone: '(11) 99999-0002', email: 'maria.oliveira@email.com' },
      { nome: 'Carlos Santos', cpf: generate_valid_cpf, telefone: '(11) 99999-0003', email: 'carlos.santos@email.com' },
      { nome: 'Ana Costa', cpf: generate_valid_cpf, telefone: '(11) 99999-0004', email: 'ana.costa@email.com' },
      { nome: 'Pedro Lima', cpf: generate_valid_cpf, telefone: '(11) 99999-0005', email: 'pedro.lima@email.com' }
    ]

    # Contador de itens criados
    itens_criados = 0
    total_antes = Cliente.count

    itens.each do |attrs|
      Cliente.find_or_create_by!(cpf: attrs[:cpf]) do |cliente|
        cliente.nome = attrs[:nome]
        cliente.telefone = attrs[:telefone]
        cliente.email = attrs[:email]
      end
    end

    itens_criados = Cliente.count - total_antes

    puts Rainbow("#{itens_criados} cliente(s) criado(s) ou já existente(s).").green
    puts Rainbow("Seed de clientes concluída com sucesso!").green.bold
  end
rescue ActiveRecord::Rollback => e
  puts Rainbow("Transação revertida devido a erros: #{e.message}").red
rescue StandardError => e
  puts Rainbow("Erro geral durante o processamento: #{e.message}").red
end