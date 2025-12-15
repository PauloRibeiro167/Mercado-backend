require "rainbow"

fornecedor1 = Fornecedor.find_by(cnpj: "12.345.678/0001-90")
fornecedor2 = Fornecedor.find_by(cnpj: "98.765.432/0001-10")
usuario = Usuario.find_by(email: "admin@test.com")

unless fornecedor1 && fornecedor2 && usuario
  puts Rainbow("Erro: Fornecedores ou usuário não encontrados. Execute a seed de fornecedores primeiro.").bold.red
  exit
end

config = {
  table_name: "pedido_compras",
  model_class: PedidoCompra,
  singular: "pedido_compra",
  plural: "pedido_compras",
  recriar_env_var: "RECRIAR_PEDIDO_COMPRAS",
  unique_key: :codigo,
  recriar: ENV["RECRIAR_PEDIDO_COMPRAS"] == "true",
  data: [
    {
      codigo: "PC001",
      fornecedor_id: fornecedor1.id,
      data_pedido: Date.today - 10.days,
      solicitacao_de_orcamento: Date.today - 10.days,
      data_recebimento: Date.today - 5.days,
      status: "recebido",
      valor_total: 1500.00,
      usuario_id: usuario.id,
      recebido: true,
      aprovado: true
    },
    {
      codigo: "PC002",
      fornecedor_id: fornecedor2.id,
      data_pedido: Date.today - 8.days,
      solicitacao_de_orcamento: Date.today - 8.days,
      data_recebimento: Date.today - 2.days,
      status: "recebido",
      valor_total: 2500.00,
      usuario_id: usuario.id,
      recebido: true,
      aprovado: true
    }
  ]
}

begin
  ActiveRecord::Base.transaction do
    if config[:recriar]
      config[:model_class].where(config[:unique_key] => config[:data].map { |r| r[config[:unique_key]] }).destroy_all
      puts Rainbow("#{config[:table_name]} existentes deletados para recriação").bold.yellow
    end

    criados = 0
    itens_atualizados = 0
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
          itens_atualizados += 1
        end
      rescue => e
        erros_ao_criar << { config[:singular].to_sym => record_attrs[:codigo], erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:codigo]}': #{e.message}"
      end
    end

    itens_criados = config[:model_class].count - total_antes

    if itens_criados == 0 && itens_atualizados == 0
      puts Rainbow("\nNenhum #{config[:singular]} novo criado, pois todos já existem").bold.yellow
    else
      puts Rainbow("\nSeed de carga de #{config[:plural]} executada com sucesso!").bold.green
    end
    puts Rainbow("Seed de carga da tabela ").bold.green + Rainbow("#{config[:table_name]} ").bold.red + Rainbow("concluída com sucesso!").bold.green
  end
rescue => e
  puts Rainbow("Erro geral na seed: #{e.message}").bold.red
end
