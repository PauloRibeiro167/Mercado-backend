require "rainbow"

usuario = Admin::Usuario.first

config = {
  table_name: "caixas",
  model_class: Pdv::Caixa,
  singular: "caixa",
  plural: "caixas",
  recriar_env_var: "RECRIAR_CAIXAS",
  unique_key: :nome,
  recriar: ENV["RECRIAR_CAIXAS"] == "true",
  data: [
    {
      nome: "Caixa Principal",
      saldo: 0.00,
      ativo: true,
      usuario: usuario
    },
    {
      nome: "Caixa Secundário",
      saldo: 0.00,
      ativo: false,
      usuario: nil
    },
    {
      nome: "Caixa terciário",
      saldo: 1500.50,
      ativo: false,
      usuario: usuario
    }
  ]
}

begin
  ActiveRecord::Base.transaction do
    if config[:recriar]
      config[:model_class].destroy_all
      puts Rainbow("#{config[:table_name]} existentes deletados para recriação").bold.yellow
    end

    criados = 0
    itens_atualizados = 0
    erros_ao_criar = []

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
        erros_ao_criar << { config[:singular].to_sym => record_attrs[:nome], erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:nome]}': #{e.message}"
      end
    end

    if criados == 0 && itens_atualizados == 0
      puts Rainbow("\nNenhum #{config[:singular]} novo criado, pois todos já existem").bold.yellow
    else
      puts Rainbow("\nSeed de carga de #{config[:plural]} executada com sucesso!").bold.green
    end
    puts Rainbow("Seed de carga da tabela ").bold.green + Rainbow("#{config[:table_name]} ").bold.red + Rainbow("concluída com sucesso!").bold.green
  end
rescue => e
  puts Rainbow("Erro geral na seed: #{e.message}").bold.red
end
