require 'rainbow'

user_ti = Usuario.find_by(email: 'ti@test.com')

config = {
  table_name: 'Cargos',
  model_class: Cargo,
  singular: 'cargo',
  plural: 'cargos',
  recriar_env_var: 'RECRIAR_CARGOS',
  unique_key: :nome,
  recriar: ENV['RECRIAR_FORNECEDORES'] == 'true',
  data: [
    {
      nome: 'Administrador',
      descricao: 'Responsável pela administração geral do sistema e configurações.',
      atribuicoes: 'Gerenciar usuários, configurar permissões, supervisionar operações e manter o sistema.',
      criado_por: user_ti
    },
    {
      nome: 'Gerente',
      descricao: 'Responsável pela gestão da equipe e operações diárias.',
      atribuicoes: 'Supervisionar funcionários, tomar decisões estratégicas, gerenciar vendas e relatórios.',
      criado_por: user_ti
    },
    {
      nome: 'Vice Gerente',
      descricao: 'Auxilia o gerente nas funções administrativas e operacionais.',
      atribuicoes: 'Monitoramento de folhas de ponto, apoio na gestão de equipe e substituição do gerente em sua ausência.',
      criado_por: user_ti
    },
    {
      nome: 'Supervisor',
      descricao: 'Auxilia o gerente na supervisão de equipe e processos.',
      atribuicoes: 'Monitorar desempenho da equipe, auxiliar em treinamentos e coordenar tarefas diárias.',
      criado_por: user_ti
    },
    {
      nome: 'Caixa',
      descricao: 'Responsável pelo controle de caixa e transações financeiras.',
      atribuicoes: 'Registrar vendas, controlar entradas e saídas de dinheiro, fechar caixa diário.',
      criado_por: user_ti
    },
    {
      nome: 'Atendente',
      descricao: 'Atende clientes e auxilia nas vendas.',
      atribuicoes: 'Receber clientes, fornecer informações sobre produtos e auxiliar no processo de compra.',
      criado_por: user_ti
    },
    {
      nome: 'Vendedor',
      descricao: 'Atua na venda de produtos e atendimento ao cliente.',
      atribuicoes: 'Atender clientes, processar vendas, manter estoque e fornecer suporte pós-venda.',
      criado_por: user_ti
    },
    {
      nome: 'Estoquista',
      descricao: 'Gerencia o estoque de produtos.',
      atribuicoes: 'Controlar entrada e saída de mercadorias, organizar estoque e reportar necessidades de reposição.',
      criado_por: user_ti
    },
    {
      nome: 'Auxiliar de Limpeza',
      descricao: 'Mantém a limpeza e organização do estabelecimento.',
      atribuicoes: 'Limpar áreas comuns, organizar espaços e auxiliar em manutenção básica.',
      criado_por: user_ti
    }
  ]
}

begin
  ActiveRecord::Base.transaction do
    if config[:recriar]
      config[:model_class].where(config[:unique_key] => config[:data].map { |r| r[config[:unique_key]] }).destroy_all
      puts Rainbow("#{config[:table_name]} existentes deletados para recriação").bold.yellow
    end

    criados = 0
    atualizados = 0
    erros_ao_criar = []
    total_antes = config[:model_class].count

    config[:data].each do |record_attrs|
      begin
        record = config[:model_class].find_or_initialize_by(config[:unique_key] => record_attrs[config[:unique_key]])
        record.assign_attributes(record_attrs)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          atualizados += 1
        end
      rescue => e
        erros_ao_criar << { config[:singular].to_sym => record_attrs[:nome], erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:nome]}': #{e.message}"
      end
    end

    itens_criados = config[:model_class].count - total_antes

    if itens_criados == 0 && atualizados == 0
      puts Rainbow("\nNenhum #{config[:singular]} novo criado, pois todos já existem").bold.yellow
    else
      puts Rainbow("\nSeed de carga de #{config[:plural]} executada com sucesso!").bold.green
    end
    puts Rainbow("Seed de carga da tabela ").bold.green + Rainbow("#{config[:table_name]} ").bold.red + Rainbow("concluída com sucesso!").bold.green
  end
rescue => e
  puts Rainbow("Erro geral na seed: #{e.message}").bold.red
end
