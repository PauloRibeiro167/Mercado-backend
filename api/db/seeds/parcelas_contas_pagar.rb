require 'rainbow'

# Buscar contas existentes para associar parcelas
conta_agua = ContaPagar.find_by(descricao: 'Conta de Água')
conta_luz = ContaPagar.find_by(descricao: 'Conta de Luz')
conta_caminhao = ContaPagar.find_by(descricao: 'Compra de Caminhão')

# Se não existirem, criar contas básicas
if !conta_agua
  metodo_pagamento = MetodoPagamento.first
  usuario = Usuario.first
  categoria = Categoria.first

  conta_agua = ContaPagar.create!(
    metodo_pagamento: metodo_pagamento,
    usuario: usuario,
    categoria: categoria,
    numero_documento: 'AGUA001',
    descricao: 'Conta de Água',
    valor: 150.00,
    data_vencimento: Date.today + 10,
    status: 'pendente',
    tipo_conta: 'agua',
    recorrente: true,
    intervalo_recorrencia: 'mensal'
  )
end

if !conta_luz
  metodo_pagamento = MetodoPagamento.first
  usuario = Usuario.first
  categoria = Categoria.first

  conta_luz = ContaPagar.create!(
    metodo_pagamento: metodo_pagamento,
    usuario: usuario,
    categoria: categoria,
    numero_documento: 'LUZ001',
    descricao: 'Conta de Luz',
    valor: 200.00,
    data_vencimento: Date.today + 15,
    status: 'pendente',
    tipo_conta: 'energia',
    recorrente: true,
    intervalo_recorrencia: 'mensal'
  )
end

if !conta_caminhao
  metodo_pagamento = MetodoPagamento.first
  usuario = Usuario.first
  categoria = Categoria.first

  conta_caminhao = ContaPagar.create!(
    metodo_pagamento: metodo_pagamento,
    usuario: usuario,
    categoria: categoria,
    numero_documento: 'CAM001',
    descricao: 'Compra de Caminhão',
    valor: 50000.00,
    data_vencimento: Date.today + 30,
    status: 'pendente',
    tipo_conta: 'outros'
  )
end

config = {
  table_name: "parcela_conta_pagars",
  model_class: ParcelaContaPagar,
  singular: "parcela_conta_pagar",
  plural: "parcelas_conta_pagar",
  recriar_env_var: "RECRIAR_PARCELAS_CONTA_PAGAR",
  recriar: ENV["RECRIAR_PARCELAS_CONTA_PAGAR"] == "true",
  data: [
    # Parcelas para caminhão (exemplo de 5 parcelas)
    {
      conta_pagar: conta_caminhao,
      numero_parcela: 1,
      valor: 10000.00,
      data_vencimento: Date.today + 30,
      paga: false
    },
    {
      conta_pagar: conta_caminhao,
      numero_parcela: 2,
      valor: 10000.00,
      data_vencimento: Date.today + 60,
      paga: false
    },
    {
      conta_pagar: conta_caminhao,
      numero_parcela: 3,
      valor: 10000.00,
      data_vencimento: Date.today + 90,
      paga: false
    },
    {
      conta_pagar: conta_caminhao,
      numero_parcela: 4,
      valor: 10000.00,
      data_vencimento: Date.today + 120,
      paga: false
    },
    {
      conta_pagar: conta_caminhao,
      numero_parcela: 5,
      valor: 10000.00,
      data_vencimento: Date.today + 150,
      paga: false
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

    config[:data].each do |record_attrs|
      begin
        record = config[:model_class].find_or_initialize_by(
          conta_pagar: record_attrs[:conta_pagar],
          numero_parcela: record_attrs[:numero_parcela]
        )
        record.assign_attributes(record_attrs)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          itens_atualizados += 1
        end
      rescue => e
        puts "Erro ao processar #{config[:singular]} parcela #{record_attrs[:numero_parcela]} da conta #{record_attrs[:conta_pagar].descricao}: #{e.message}"
      end
    end

    if criados.zero? && itens_atualizados.zero?
      puts Rainbow("\nNenhuma #{config[:singular]} nova criada, pois todas já existem").bold.yellow
    else
      puts Rainbow("\nSeed de carga de #{config[:plural]} executada com sucesso!").bold.green
    end

    puts Rainbow("Seed de carga da tabela ").bold.green +
         Rainbow("#{config[:table_name]} ").bold.red +
         Rainbow("concluída com sucesso!").bold.green
  end
rescue => e
  puts Rainbow("Erro geral na seed: #{e.message}").bold.red
end