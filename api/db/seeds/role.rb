require 'rainbow'

config = {
  table_name: "Roles",
  model_class: Admin::Role,
  singular: "role",
  plural: "roles",
  recriar_env_var: 'RECRIAR_ROLES',
  unique_key: :name,
  recriar: ENV['RECRIAR_ROLES'] == 'true',
  data: [
    { name: "usuario" },
    { name: "admin" },
    { name: "ti" },
    { name: "Vendedor" },
    { name: "Gerente" },
    { name: "Administrador" },
    { name: "Vice Gerente" },
    { name: "Supervisor" },
    { name: "Caixa" },
    { name: "Atendente" },
    { name: "Estoquista" },
    { name: "Auxiliar de Limpeza" }
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
        erros_ao_criar << { config[:singular].to_sym => record_attrs[:name], erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:name]}': #{e.message}"
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

# Role.find_or_create_by(name: "usuario")
# Role.find_or_create_by(name: "admin")
# Role.find_or_create_by(name: "ti")

# if Role.where(name: [ "usuario", "admin", "ti" ]).count == 3
#   puts "Papeis criados"
# else
#   puts "Erro ao criar alguns papeis"
# end
