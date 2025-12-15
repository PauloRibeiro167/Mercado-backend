require 'rainbow'

config = {
  table_name: 'tipos_contratos',
  model_class: TiposContrato,
  singular: 'tipo_contrato',
  plural: 'tipos_contrato',
  recriar_env_var: 'RECRIAR_TIPOS_CONTRATO',
  unique_key: :nome,
  data: [
    { nome: 'fixo', descricao: 'Contrato fixo' },
    { nome: 'freelancer', descricao: 'Contrato freelancer' },
    { nome: 'temporário', descricao: 'Contrato temporário' },
    { nome: 'estágio', descricao: 'Contrato de estágio' },
    { nome: 'terceirizado', descricao: 'Contrato terceirizado' },
    { nome: 'primeiro emprego', descricao: 'Contrato para primeiro emprego' },
    { nome: 'experiência', descricao: 'Período de experiência' },
    { nome: 'CLT', descricao: 'Contrato regido pela CLT' },
    { nome: 'PJ', descricao: 'Pessoa Jurídica' },
    { nome: 'autônomo', descricao: 'Contrato autônomo' },
    { nome: 'aprendiz', descricao: 'Contrato de aprendizagem' },
    { nome: 'consultor', descricao: 'Contrato de consultoria' }
  ]
}

begin
  ActiveRecord::Base.transaction do
    if ENV[config[:recriar_env_var]] == 'true'
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
