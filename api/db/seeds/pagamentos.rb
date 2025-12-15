require "rainbow"

pedido_compra1 = PedidoCompra.find_by(codigo: "PC001")
pedido_compra2 = PedidoCompra.find_by(codigo: "PC002")
usuario = Usuario.first

unless pedido_compra1 && pedido_compra2 && usuario
  puts Rainbow("Erro: Pedidos de compra ou usuário não encontrados. Execute as seeds anteriores primeiro.").bold.red
  exit
end

config = {
  table_name: "pagamentos",
  model_class: Pagamento,
  singular: "pagamento",
  plural: "pagamentos",
  recriar_env_var: "RECRIAR_PAGAMENTOS",
  recriar: ENV["RECRIAR_PAGAMENTOS"] == "true",
  data: [
    {
      pedido_compras_id: pedido_compra1.id,
      tipo_pagamento: "boleto",
      usuario_id: usuario.id,
      valor_pago: 1500.00,
      data_pagamento: Date.today,
      observacao: "Pagamento via boleto bancário"
    },
    {
      pedido_compras_id: pedido_compra2.id,
      tipo_pagamento: "pix",
      usuario_id: usuario.id,
      valor_pago: 1250.00,
      data_pagamento: Date.today,
      observacao: "Pagamento via PIX"
    },
    {
      pedido_compras_id: pedido_compra2.id,
      tipo_pagamento: "cartao",
      usuario_id: usuario.id,
      valor_pago: 1250.00,
      data_pagamento: Date.today,
      observacao: "Pagamento com cartão de crédito"
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
    erros_ao_criar = []
    total_antes = config[:model_class].count

    config[:data].each do |record_attrs|
      begin
        record = config[:model_class].new(record_attrs)
        record.save!
        criados += 1
      rescue => e
        erros_ao_criar << { config[:singular].to_sym => record_attrs, erro: e.message }
        puts "Erro ao processar #{config[:singular]}: #{e.message}"
      end
    end

    itens_criados = config[:model_class].count - total_antes

    if itens_criados == 0
      puts Rainbow("\nNenhum #{config[:singular]} novo criado").bold.yellow
    else
      puts Rainbow("\nSeed de carga de #{config[:plural]} executada com sucesso!").bold.green
    end
    puts Rainbow("Seed de carga da tabela ").bold.green + Rainbow("#{config[:table_name]} ").bold.red + Rainbow("concluída com sucesso!").bold.green
  end
rescue => e
  puts Rainbow("Erro geral na seed: #{e.message}").bold.red
end
