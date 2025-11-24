# Seeds para cargos
# Este arquivo populates a tabela `cargos` de forma idempotente.
# Use `Cargo.find_or_create_by!` para não quebrar com o índice único em :nome.

require 'rainbow'

# Criar cargos
puts Rainbow("Iniciando seed de cargos...").blue

begin
  ActiveRecord::Base.transaction do
    puts Rainbow("Criando cargos...").blue

    # Usar usuário existente para criado_por
    usuario_admin = Usuario.find_by!(email: 'admin@test.com')

    # Array de dados para criar
    itens = [
      {
        nome: 'Administrador',
        descricao: 'Responsável pela administração geral do sistema e configurações.',
        atribuicoes: 'Gerenciar usuários, configurar permissões, supervisionar operações e manter o sistema.',
        criado_por: usuario_admin
      },
      {
        nome: 'Gerente',
        descricao: 'Responsável pela gestão da equipe e operações diárias.',
        atribuicoes: 'Supervisionar funcionários, tomar decisões estratégicas, gerenciar vendas e relatórios.',
        criado_por: usuario_admin
      },
      {
        nome: "Vice Gerente",
        descricao: "Auxilia o gerente nas funções administrativas e operacionais.",
        atribuicoes: "Monitoramento de folhas de ponto, apoio na gestão de equipe e substituição do gerente em sua ausência.",
        criado_por: user_ti
      },
      {
        nome: 'Supervisor',
        descricao: 'Auxilia o gerente na supervisão de equipe e processos.',
        atribuicoes: 'Monitorar desempenho da equipe, auxiliar em treinamentos e coordenar tarefas diárias.',
        criado_por: usuario_admin
      },
      {
        nome: 'Caixa',
        descricao: 'Responsável pelo controle de caixa e transações financeiras.',
        atribuicoes: 'Registrar vendas, controlar entradas e saídas de dinheiro, fechar caixa diário.',
        criado_por: usuario_admin
      },
      {
        nome: 'Atendente',
        descricao: 'Atende clientes e auxilia nas vendas.',
        atribuicoes: 'Receber clientes, fornecer informações sobre produtos e auxiliar no processo de compra.',
        criado_por: usuario_admin
      },
      {
        nome: 'Vendedor',
        descricao: 'Atua na venda de produtos e atendimento ao cliente.',
        atribuicoes: 'Atender clientes, processar vendas, manter estoque e fornecer suporte pós-venda.',
        criado_por: usuario_admin
      },
      {
        nome: 'Estoquista',
        descricao: 'Gerencia o estoque de produtos.',
        atribuicoes: 'Controlar entrada e saída de mercadorias, organizar estoque e reportar necessidades de reposição.',
        criado_por: usuario_admin
      },
      {
        nome: 'Auxiliar de Limpeza',
        descricao: 'Mantém a limpeza e organização do estabelecimento.',
        atribuicoes: 'Limpar áreas comuns, organizar espaços e auxiliar em manutenção básica.',
        criado_por: usuario_admin
      }
    ]

    # Contador de itens criados
    itens_criados = 0
    total_antes = Cargo.count

    itens.each do |attrs|
      Cargo.find_or_create_by!(nome: attrs[:nome]) do |c|
        c.assign_attributes(attrs)
      end
    end

    itens_criados = Cargo.count - total_antes

    puts Rainbow("#{itens_criados} cargo(s) criado(s) ou já existente(s).").green
    puts Rainbow("Seed de cargos concluída com sucesso!").green.bold
  end
rescue ActiveRecord::Rollback => e
  puts Rainbow("Transação revertida devido a erros: #{e.message}").red
rescue StandardError => e
  puts Rainbow("Erro geral durante o processamento: #{e.message}").red
end
