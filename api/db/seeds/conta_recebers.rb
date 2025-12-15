require 'rainbow'

# Assumindo que você tenha instâncias válidas para associações obrigatórias
# Substitua por buscas reais ou crie seeds para elas primeiro
venda = Venda.first # Exemplo: ajuste conforme necessário
cliente = Cliente.first
metodo_pagamento = MetodoPagamento.first
usuario = Usuario.first
categoria = Categoria.first

config = {
  table_name: "conta_recebers",
  model_class: ContaReceber,
  singular: "conta_receber",
  plural: "conta_recebers",
  recriar_env_var: "RECRIAR_CONTA_RECEBERS",
  unique_key: :numero_documento,
  recriar: ENV["RECRIAR_CONTA_RECEBERS"] == "true",
  data: [
    {
      venda: venda,
      cliente: cliente,
      metodo_pagamento: metodo_pagamento,
      usuario: usuario,
      categoria: categoria,
      numero_documento: 'REC001',
      valor_original: 2000.50,
      descricao: 'Recebimento de venda',
      valor: 2000.50,
      data_vencimento: Date.today + 30,
      data_recebimento: nil,
      status: 'pendente',
      tipo_conta: 'venda',
      recorrente: false,
      intervalo_recorrencia: nil,
      numero_recorrencias: 0,
      data_proxima_recorrencia: nil,
      paga: false
    },
    {
      venda: venda,
      cliente: cliente,
      metodo_pagamento: metodo_pagamento,
      usuario: usuario,
      categoria: categoria,
      numero_documento: 'REC002',
      valor_original: 1500.00,
      descricao: 'Recebimento de aluguel',
      valor: 1500.00,
      data_vencimento: Date.today + 15,
      data_recebimento: Date.today,
      status: 'pago',
      tipo_conta: 'aluguel',
      recorrente: true,
      intervalo_recorrencia: 'mensal',
      numero_recorrencias: 12,
      data_proxima_recorrencia: Date.today + 30,
      paga: true
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
