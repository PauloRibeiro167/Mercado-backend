# Template genérico para seeds no projeto Mercadinho
# Este arquivo serve como base para criar novos arquivos de seeds.
# Substitua [NomeDoModelo] pelo nome do modelo (ex: Cargo, Produto).
# Substitua [itens] pelos dados a serem criados.
# Mantenha o padrão de formatação com rainbow para mensagens coloridas.

require 'rainbow'

# [Descrição breve do que o seed faz]
puts Rainbow("Iniciando seed de [nomes]...").blue

begin
  ActiveRecord::Base.transaction do
    puts Rainbow("Criando [nomes]...").blue

    # Array de dados para criar
    itens = [
      # Exemplo: { nome: 'Exemplo' },
      # Adicione seus dados aqui
    ]

    # Contador de itens criados
    itens_criados = 0
    total_antes = [NomeDoModelo].count

    itens.each do |attrs|
      # Ajuste conforme o modelo: [NomeDoModelo].find_or_create_by!(attrs)
      # Exemplo: [NomeDoModelo].find_or_create_by!(nome: attrs[:nome])
    end

    itens_criados = [NomeDoModelo].count - total_antes

    puts Rainbow("#{itens_criados} [nome](s) criado(s) ou já existente(s).").green
    puts Rainbow("Seed de [nomes] concluída com sucesso!").green.bold
  end
rescue ActiveRecord::Rollback => e
  puts Rainbow("Transação revertida devido a erros: #{e.message}").red
rescue StandardError => e
  puts Rainbow("Erro geral durante o processamento: #{e.message}").red
end