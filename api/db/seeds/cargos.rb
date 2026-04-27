require 'rainbow'

user_ti = Admin::Usuario.find_by(email: 'ti@test.com')

config = {
  table_name: 'Cargos',
  model_class: Rh::Cargo,
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
      nome: 'sub-Gerente',
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
    },
    {
      nome: 'Açougueiro',
      descricao: 'Responsável pelo setor de carnes.',
      atribuicoes: 'Corte, pesagem, embalagem, controle de qualidade das carnes e atendimento ao cliente no balcão.',
      criado_por: user_ti
    },
    {
      nome: 'Padeiro',
      descricao: 'Responsável pela produção de pães e derivados.',
      atribuicoes: 'Preparar massas, assar pães, organizar vitrine da padaria e controlar validade dos insumos.',
      criado_por: user_ti
    },
    {
      nome: 'Repositor',
      descricao: 'Responsável por manter as prateleiras abastecidas.',
      atribuicoes: 'Repor produtos nas gôndolas, verificar datas de validade no salão de vendas e precificar mercadorias.',
      criado_por: user_ti
    },
    {
      nome: 'Fiscal de Loja',
      descricao: 'Atua na prevenção de perdas e segurança do local.',
      atribuicoes: 'Monitorar o ambiente, prevenir furtos, conferir cupons fiscais e apoiar em situações de emergência.',
      criado_por: user_ti
    },
    {
      nome: 'Empacotador',
      descricao: 'Auxilia no empacotamento das compras dos clientes.',
      atribuicoes: 'Embalar produtos de forma organizada e ágil, recolher carrinhos e apoiar o operador de caixa.',
      criado_por: user_ti
    },
    {
      nome: 'Conferente',
      descricao: 'Verifica as mercadorias recebidas e despachadas.',
      atribuicoes: 'Conferir notas fiscais, inspecionar a qualidade e quantidade dos produtos recebidos dos fornecedores.',
      criado_por: user_ti
    },
    {
      nome: 'Analista de TI',
      descricao: 'Suporte técnico e manutenção dos sistemas do mercado.',
      atribuicoes: 'Manter PDVs funcionando, dar suporte à rede, balanças, impressoras e resolver problemas no software.',
      criado_por: user_ti
    },
    {
      nome: 'Segurança',
      descricao: 'Responsável pela vigilância e integridade física do local.',
      atribuicoes: 'Controlar acesso de pessoas, garantir a segurança patrimonial, de clientes e funcionários.',
      criado_por: user_ti
    },
    {
      nome: 'Encarregado de Hortifruti',
      descricao: 'Especialista no setor de Frutas, Legumes e Verduras (FLV).',
      atribuicoes: 'Selecionar, higienizar, organizar expositores e descartar produtos avariados para garantir frescor.',
      criado_por: user_ti
    },
    {
      nome: 'Cartazista',
      descricao: 'Responsável pela comunicação visual de preços e ofertas.',
      atribuicoes: 'Confeccionar cartazes, faixas promocionais e etiquetas de precificação para gôndolas e ilhas.',
      criado_por: user_ti
    },
    {
      nome: 'Motorista / Entregador',
      descricao: 'Realiza a entrega das compras e mercadorias.',
      atribuicoes: 'Conduzir veículo da empresa, conferir pedidos, organizar rotas e entregar compras aos clientes.',
      criado_por: user_ti
    },
    {
      nome: 'Auxiliar Administrativo',
      descricao: 'Atua no suporte de backoffice do estabelecimento.',
      atribuicoes: 'Lançamento de notas fiscais, auxílio no controle de ponto, faturamento e contas a pagar/receber.',
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
