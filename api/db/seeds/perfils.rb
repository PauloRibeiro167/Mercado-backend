require 'rainbow'

RECRIAR_PERFIS = ENV['RECRIAR_PERFIS'] == 'true'

config = {
  table_name: 'Perfis',
  model_class: Admin::Perfil,
  singular: 'perfil',
  plural: 'perfis',
  recriar_env_var: 'RECRIAR_PERFIS',
  unique_key: :nome,
  recriar: RECRIAR_PERFIS,
  data: [
    { nome: 'Admin', descricao: 'Perfil com acesso total ao sistema' },
    { nome: 'Gerente', descricao: 'Perfil para gerenciar operações do mercadinho' },
    { nome: 'Funcionário', descricao: 'Perfil básico para funcionários' },
    { nome: 'Repositor', descricao: 'Perfil para gerenciar estoque e reposição de produtos' },
    { nome: 'Caixa', descricao: 'Perfil para operar o caixa e vendas' },
    { nome: 'Subgerente', descricao: 'Perfil de subgerente com acesso intermediário' },
    { nome: 'TI', descricao: 'Perfil para equipe de tecnologia da informação' },
    { nome: 'Cliente', descricao: 'Perfil para clientes com acesso limitado' },
    { nome: 'Açougueiro', descricao: 'Responsável pelo setor de carnes' },
    { nome: 'Padaria', descricao: 'Responsável pela produção e venda de pães e doces' },
    { nome: 'Hortifruteiro', descricao: 'Responsável pelo setor de frutas, verduras e legumes' },
    { nome: 'Atendente de Balcão', descricao: 'Atendimento ao cliente em balcões específicos' },
    { nome: 'Gerente de Vendas', descricao: 'Foco em vendas e metas de vendas' },
    { nome: 'Gerente de Estoque', descricao: 'Controle de inventário e reposição' },
    { nome: 'Comprador', descricao: 'Negociações com fornecedores' },
    { nome: 'Contador', descricao: 'Gestão financeira e contábil' },
    { nome: 'Limpeza', descricao: 'Equipe de limpeza e manutenção' },
    { nome: 'Segurança', descricao: 'Vigilância e segurança do estabelecimento' },
    { nome: 'RH', descricao: 'Gestão de recursos humanos' },
    { nome: 'Marketing', descricao: 'Promoções e publicidade' },
    { nome: 'Entregador', descricao: 'Entrega de produtos aos clientes' },
    { nome: 'Estoquista', descricao: 'Organização e controle de estoque' },
    { nome: 'Supervisor de Turno', descricao: 'Supervisão durante horários específicos' }
  ]
}


begin
  ActiveRecord::Base.transaction do
    if config[:recriar]
      config[:model_class].where(config[:unique_key] => config[:data].map { |r| r[config[:unique_key]] }).destroy_all
      puts Rainbow("#{config[:table_name]} existentes deletados para recriação").bold.yellow
    end

    criados = 0
    itens_atualizados = 0
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
          itens_atualizados += 1
        end
      rescue => e
        erros_ao_criar << { config[:singular].to_sym => record_attrs[:codigo], erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:codigo]}': #{e.message}"
      end
    end

    itens_criados = config[:model_class].count - total_antes

    if itens_criados == 0 && itens_atualizados == 0  # Corrigido para usar a variável renomeada
      puts Rainbow("\nNenhum #{config[:singular]} novo criado, pois todos já existem").bold.yellow
    else
      puts Rainbow("\nSeed de carga de #{config[:plural]} executada com sucesso!").bold.green
    end
    puts Rainbow("Seed de carga da tabela ").bold.green + Rainbow("#{config[:table_name]} ").bold.red + Rainbow("concluída com sucesso!").bold.green
  end
rescue => e
  puts Rainbow("Erro geral na seed: #{e.message}").bold.red
end
