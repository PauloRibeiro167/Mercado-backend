require "rainbow"

config = {
  table_name: "vendas",
  model_class: Venda,
  singular: "venda",
  plural: "vendas",
  recriar_env_var: "RECRIAR_VENDAS",
  unique_key: :numero_venda,
  recriar: ENV["RECRIAR_VENDAS"] == "true",
  data: [
    {
      cliente_nome: "João Silva",
      metodo_pagamento_nome: "Dinheiro",
      sessao_caixa_id: nil,
      status: :concluida,
      valor_pago: 15.99,
      item_vendas: [
        { lote_codigo: "LOTE001", quantidade: 2, preco_unitario_vendido: 5.99 },
        { lote_codigo: "LOTE002", quantidade: 1, preco_unitario_vendido: 4.50 }
      ]
    },
    {
      cliente_nome: "Maria Oliveira",
      metodo_pagamento_nome: "Cartão de Crédito",
      sessao_caixa_id: nil,
      status: :concluida,
      valor_pago: 25.00,
      numero_parcelas: 2,
      item_vendas: [
        { lote_codigo: "LOTE001", quantidade: 1, preco_unitario_vendido: 10.00 },
        { lote_codigo: "LOTE002", quantidade: 1, preco_unitario_vendido: 15.00 }
      ]
    },
    {
      cliente_nome: nil,
      metodo_pagamento_nome: "Pix",
      sessao_caixa_id: nil,
      status: :pendente,
      valor_pago: nil,
      item_vendas: [
        { lote_codigo: "LOTE001", quantidade: 3, preco_unitario_vendido: 8.33 }
      ]
    },
    {
      cliente_nome: "Carlos Santos",
      metodo_pagamento_nome: "Dinheiro",
      sessao_caixa_id: nil,
      status: :cancelada,
      valor_pago: 0.00,
      motivo_cancelamento: "Cliente desistiu",
      detalhes_cancelamento: "Produto fora de estoque",
      item_vendas: [
        { lote_codigo: "LOTE002", quantidade: 1, preco_unitario_vendido: 12.00 }
      ]
    },
    {
      cliente_nome: "Ana Costa",
      metodo_pagamento_nome: "Cartão de Débito",
      sessao_caixa_id: nil,
      status: :concluida,
      valor_pago: 50.00,
      item_vendas: [
        { lote_codigo: "LOTE001", quantidade: 2, preco_unitario_vendido: 20.00 },
        { lote_codigo: "LOTE002", quantidade: 1, preco_unitario_vendido: 10.00 }
      ]
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
        record_attrs_modified = record_attrs.dup
        cliente = record_attrs[:cliente_nome] ? Cliente.find_by(nome: record_attrs[:cliente_nome]) : nil
        metodo = MetodoPagamento.find_by(nome: record_attrs[:metodo_pagamento_nome])
        unless metodo
          erros_ao_criar << { venda: record_attrs[:cliente_nome] || 'Sem cliente', erro: "Método de pagamento '#{record_attrs[:metodo_pagamento_nome]}' não encontrado" }
          puts "Erro ao processar #{config[:singular]} '#{record_attrs[:cliente_nome] || 'Sem cliente'}': Método de pagamento não encontrado"
          next
        end
        record_attrs_modified[:cliente] = cliente
        record_attrs_modified[:metodo_pagamento] = metodo
        item_vendas = record_attrs_modified.delete(:item_vendas)
        record_attrs_modified.delete(:cliente_nome)
        record_attrs_modified.delete(:metodo_pagamento_nome)

        record = config[:model_class].find_or_initialize_by(config[:unique_key] => record_attrs_modified[config[:unique_key]])
        record.assign_attributes(record_attrs_modified)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          itens_atualizados += 1
        end

        # Criar ItemVendas após salvar a venda
        item_vendas.each do |item_attrs|
          lote = Lote.find_by(codigo: item_attrs[:lote_codigo])
          unless lote
            puts "Lote '#{item_attrs[:lote_codigo]}' não encontrado. Pulando item."
            next
          end
          ItemVenda.find_or_create_by!(
            venda: record,
            lote: lote,
            quantidade: item_attrs[:quantidade],
            preco_unitario_vendido: item_attrs[:preco_unitario_vendido]
          )
        end

        record.calcular_totais
        record.calcular_troco
      rescue => e
        erros_ao_criar << { venda: record_attrs[:cliente_nome] || 'Sem cliente', erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:cliente_nome] || 'Sem cliente'}': #{e.message}"
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
