require "rainbow"

config = {
  table_name: "folha_pagamentos",
  model_class: Rh::FolhaPagamento,
  singular: "folha_pagamento",
  plural: "folha_pagamentos",
  recriar_env_var: "RECRIAR_FOLHA_PAGAMENTOS",
  recriar: ENV["RECRIAR_FOLHA_PAGAMENTOS"] == "true",
  data: [
    {
      funcionario_nome: "Funcionário Exemplo",
      usuario_email: "admin@test.com",
      data_referencia: Date.new(2025, 12, 1),
      dias_trabalhados: 20,
      horas_extras: 5.0,
      salario_base: 2000.00,
      adicional_horas_extras: 150.00,
      inss: 200.00,
      fgts: 160.00,
      total_liquido: 1790.00,
      processada: false,
      conta_pagar_id: nil
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
        funcionario = Rh::Funcionario.find_by(nome: record_attrs[:funcionario_nome])
        unless funcionario
          erros_ao_criar << { item: "funcionario #{record_attrs[:funcionario_nome]}", erro: "Funcionário não encontrado" }
          puts "Erro ao processar #{config[:singular]} para funcionario #{record_attrs[:funcionario_nome]}: Funcionário não encontrado"
          next
        end

        usuario = Admin::Usuario.find_by(email: record_attrs[:usuario_email])
        unless usuario
          erros_ao_criar << { item: "usuario #{record_attrs[:usuario_email]}", erro: "Usuário não encontrado" }
          puts "Erro ao processar #{config[:singular]} para usuario #{record_attrs[:usuario_email]}: Usuário não encontrado"
          next
        end

        record_attrs_modified = record_attrs.except(:funcionario_nome, :usuario_email).merge(funcionario: funcionario, usuario: usuario)

        record = config[:model_class].find_or_initialize_by(funcionario: funcionario, data_referencia: record_attrs[:data_referencia])
        record.assign_attributes(record_attrs_modified)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          itens_atualizados += 1
        end
      rescue => e
        erros_ao_criar << { item: "#{record_attrs[:funcionario_nome]}-#{record_attrs[:data_referencia]}", erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:funcionario_nome]}-#{record_attrs[:data_referencia]}': #{e.message}"
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
