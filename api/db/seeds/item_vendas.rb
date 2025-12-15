require "rainbow"

config = {
  table_name: "item_vendas",
  model_class: ItemVenda,
  singular: "item_venda",
  plural: "itens de venda",
  recriar_env_var: "RECRIAR_ITEM_VENDAS",
  recriar: ENV["RECRIAR_ITEM_VENDAS"] == "true",
  data: [
    {
      venda_numero: 1,
      lote_codigo: "LOTE001",
      quantidade: 2,
      preco_unitario_vendido: 5.99
    },
    {
      venda_numero: 1,
      lote_codigo: "LOTE002",
      quantidade: 1,
      preco_unitario_vendido: 4.50
    },
    {
      venda_numero: 2,
      lote_codigo: "LOTE001",
      quantidade: 1,
      preco_unitario_vendido: 10.00
    },
    {
      venda_numero: 2,
      lote_codigo: "LOTE002",
      quantidade: 1,
      preco_unitario_vendido: 15.00
    },
    {
      venda_numero: 3,
      lote_codigo: "LOTE001",
      quantidade: 3,
      preco_unitario_vendido: 8.33
    },
    {
      venda_numero: 4,
      lote_codigo: "LOTE002",
      quantidade: 1,
      preco_unitario_vendido: 12.00
    },
    {
      venda_numero: 5,
      lote_codigo: "LOTE001",
      quantidade: 2,
      preco_unitario_vendido: 20.00
    },
    {
      venda_numero: 5,
      lote_codigo: "LOTE002",
      quantidade: 1,
      preco_unitario_vendido: 10.00
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
        venda = Venda.find_by(numero_venda: record_attrs[:venda_numero])
        unless venda
          erros_ao_criar << { item: "venda #{record_attrs[:venda_numero]}", erro: "Venda não encontrada" }
          puts "Erro ao processar #{config[:singular]} para venda #{record_attrs[:venda_numero]}: Venda não encontrada"
          next
        end

        lote = Lote.find_by(codigo: record_attrs[:lote_codigo])
        unless lote
          erros_ao_criar << { item: "lote #{record_attrs[:lote_codigo]}", erro: "Lote não encontrado" }
          puts "Erro ao processar #{config[:singular]} para lote #{record_attrs[:lote_codigo]}: Lote não encontrado"
          next
        end

        record_attrs_modified = record_attrs.except(:venda_numero, :lote_codigo).merge(venda: venda, lote: lote)

        record = config[:model_class].find_or_initialize_by(venda: venda, lote: lote)
        record.assign_attributes(record_attrs_modified)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          itens_atualizados += 1
        end
      rescue => e
        erros_ao_criar << { item: "#{record_attrs[:venda_numero]}-#{record_attrs[:lote_codigo]}", erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:venda_numero]}-#{record_attrs[:lote_codigo]}': #{e.message}"
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
