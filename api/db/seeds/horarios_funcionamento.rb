require "rainbow"

config = {
  table_name: "horarios_funcionamentos",
  model_class: HorarioFuncionamento,
  singular: "horario_funcionamento",
  plural: "horarios_funcionamento",
  recriar_env_var: "RECRIAR_HORARIOS_FUNCIONAMENTO",
  recriar: ENV["RECRIAR_HORARIOS_FUNCIONAMENTO"] == "true",
  data: [
    {
      dia_semana: 'segunda',
      data_especial: nil,
      hora_inicio: '08:00',
      hora_fim: '18:00',
      tipo: 'normal',
      ativo: true,
      observacao: 'Horário normal de segunda-feira'
    },
    {
      dia_semana: 'terca',
      data_especial: nil,
      hora_inicio: '08:00',
      hora_fim: '18:00',
      tipo: 'normal',
      ativo: true,
      observacao: 'Horário normal de terça-feira'
    },
    {
      dia_semana: nil,
      data_especial: Date.new(2025, 12, 25),
      hora_inicio: '10:00',
      hora_fim: '16:00',
      tipo: 'reduzido',
      ativo: true,
      observacao: 'Funcionamento reduzido no Natal'
    },
    {
      dia_semana: nil,
      data_especial: Date.new(2025, 1, 1),
      hora_inicio: nil,
      hora_fim: nil,
      tipo: 'feriado',
      ativo: true,
      observacao: 'Fechado no Ano Novo'
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
        record = config[:model_class].find_or_initialize_by(dia_semana: record_attrs[:dia_semana], data_especial: record_attrs[:data_especial])
        record.assign_attributes(record_attrs)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          itens_atualizados += 1
        end
      rescue => e
        erros_ao_criar << { item: "#{record_attrs[:dia_semana] || record_attrs[:data_especial]}", erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:dia_semana] || record_attrs[:data_especial]}': #{e.message}"
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
