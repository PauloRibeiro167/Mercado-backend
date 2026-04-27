require "rainbow"

config = {
  table_name: "item_pedido_compras",
  model_class: Estoque::ItemPedidoCompra,
  singular: "item_pedido_compra",
  plural: "item_pedido_compras",
  recriar_env_var: "RECRIAR_ITEM_PEDIDO_COMPRAS",
  unique_key: [ :pedido_compra_id, :produto_id ],
  recriar: ENV["RECRIAR_ITEM_PEDIDO_COMPRAS"] == "true",
  data: [
    {
      pedido_compra_codigo: "PC001",
      produto_nome: "Maçã Gala",
      quantidade_pedida: 100,
      quantidade_recebida: 95,
      preco_unitario: 4.50,
      desconto: 0.0,
      data_validade: "2025-12-15",
      numero_lote: "LOTE-APPLE-001",
      status: "parcialmente_recebido",
      data_recebimento: "2025-12-01 10:00:00",
      observacoes: "Faltaram 5 unidades devido a avaria no transporte"
    },
    {
      pedido_compra_codigo: "PC001",
      produto_nome: "Banana Prata",
      quantidade_pedida: 200,
      quantidade_recebida: 200,
      preco_unitario: 3.00,
      desconto: 0.0,
      data_validade: "2025-12-10",
      numero_lote: "LOTE-BANANA-001",
      status: "recebido",
      data_recebimento: "2025-12-01 10:00:00",
      observacoes: nil
    },
    {
      pedido_compra_codigo: "PC002",
      produto_nome: "Laranja Bahia",
      quantidade_pedida: 150,
      quantidade_recebida: 150,
      preco_unitario: 2.50,
      desconto: 0.0,
      data_validade: "2025-12-20",
      numero_lote: "LOTE-LARANJA-001",
      status: "recebido",
      data_recebimento: "2025-12-02 14:00:00",
      observacoes: nil
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
    atualizados = 0
    erros_ao_criar = []
    total_antes = config[:model_class].count

    config[:data].each do |record_attrs|
      begin
        pedido = Estoque::PedidoCompra.find_by(codigo: record_attrs[:pedido_compra_codigo])
        produto = Estoque::Produto.find_by(nome: record_attrs[:produto_nome])
        unless pedido && produto
          puts "Pedido ou produto não encontrado para item: #{record_attrs[:pedido_compra_codigo]} - #{record_attrs[:produto_nome]}. Pulando."
          next
        end
        record_attrs_mapped = record_attrs.merge(
          pedido_compra_id: pedido.id,
          produto_id: produto.id
        ).except(:pedido_compra_codigo, :produto_nome)
        record = config[:model_class].find_or_initialize_by(pedido_compra_id: pedido.id, produto_id: produto.id)
        record.assign_attributes(record_attrs_mapped)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          atualizados += 1
        end
      rescue => e
        erros_ao_criar << { item: "#{record_attrs[:pedido_compra_codigo]} - #{record_attrs[:produto_nome]}", erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:pedido_compra_codigo]} - #{record_attrs[:produto_nome]}': #{e.message}"
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
