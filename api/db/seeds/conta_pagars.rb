require 'rainbow'

metodo_pagamento = MetodoPagamento.first
usuario = Usuario.first
categoria = Categoria.first

fornecedor1 = Fornecedor.find_by(cnpj: "12.345.678/0001-90")
fornecedor2 = Fornecedor.find_by(cnpj: "98.765.432/0001-10")
pedido1 = PedidoCompra.find_by(codigo: "PC001")
pedido2 = PedidoCompra.find_by(codigo: "PC002")

config = {
  table_name: "conta_pagars",
  model_class: ContaPagar,
  singular: "conta_pagar",
  plural: "conta_pagars",
  recriar_env_var: "RECRIAR_CONTA_PAGARS",
  unique_key: :numero_documento,
  recriar: ENV["RECRIAR_CONTA_PAGARS"] == "true",
  data: [
    {
      fornecedor: fornecedor1,
      pedido_compra: pedido1,
      metodo_pagamento: metodo_pagamento,
      usuario: usuario,
      categoria: categoria,
      numero_documento: 'DOC001',
      valor_original: 1500.50,
      descricao: 'Pagamento de mercadorias',
      valor: 1500.50,
      data_vencimento: Date.today + 30,
      data_pagamento: nil,
      status: 'pendente',
      tipo_conta: 'fornecedor'
    },
    {
      fornecedor: fornecedor2,
      pedido_compra: pedido2,
      metodo_pagamento: metodo_pagamento,
      usuario: usuario,
      categoria: categoria,
      numero_documento: 'DOC002',
      valor_original: 2500.00,
      descricao: 'Compra de equipamentos',
      valor: 2500.00,
      data_vencimento: Date.today + 15,
      data_pagamento: Date.today,
      status: 'pago',
      tipo_conta: 'fornecedor'
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
        erros_ao_criar << { config[:singular].to_sym => record_attrs[config[:unique_key]], erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[config[:unique_key]]}': #{e.message}"
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
