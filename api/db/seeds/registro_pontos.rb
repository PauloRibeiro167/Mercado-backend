require "rainbow"

config = {
  table_name: "registro_pontos",
  model_class: RegistroPonto,
  singular: "registro_ponto",
  plural: "registro_pontos",
  recriar_env_var: "RECRIAR_REGISTRO_PONTOS",
  recriar: ENV["RECRIAR_REGISTRO_PONTOS"] == "true",
  data: [
    {
      funcionario_nome: "Funcionário Exemplo",
      data: Date.new(2025, 12, 1),
      hora_entrada: "08:00",
      hora_saida: "17:00",
      aprovado: true
    },
    {
      funcionario_nome: "Funcionário Exemplo",
      data: Date.new(2025, 12, 2),
      hora_entrada: "08:00",
      hora_saida: "18:00",
      aprovado: false
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
        funcionario = Funcionario.find_by(nome: record_attrs[:funcionario_nome])
        unless funcionario
          erros_ao_criar << { item: "funcionario #{record_attrs[:funcionario_nome]}", erro: "Funcionário não encontrado" }
          puts "Erro ao processar #{config[:singular]} para funcionario #{record_attrs[:funcionario_nome]}: Funcionário não encontrado"
          next
        end

        record_attrs_modified = record_attrs.except(:funcionario_nome).merge(funcionario: funcionario)

        record = config[:model_class].find_or_initialize_by(funcionario: funcionario, data: record_attrs[:data])
        record.assign_attributes(record_attrs_modified)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          itens_atualizados += 1
        end
      rescue => e
        erros_ao_criar << { item: "#{record_attrs[:funcionario_nome]}-#{record_attrs[:data]}", erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:funcionario_nome]}-#{record_attrs[:data]}': #{e.message}"
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
