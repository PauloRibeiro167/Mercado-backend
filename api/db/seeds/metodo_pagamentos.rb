require 'rainbow'

config = {
  table_name: "metodo_pagamentos",
  model_class: Financeiro::MetodoPagamento,
  singular: "metodo_pagamento",
  plural: "metodo_pagamentos",
  recriar_env_var: "RECRIAR_METODO_PAGAMENTOS",
  unique_key: :nome,
  recriar: ENV["RECRIAR_METODO_PAGAMENTOS"] == "true",
  data: [
    {
      nome: 'Dinheiro',
      tipo: :dineiro,
      descricao: 'Pagamento em dinheiro',
      taxa_percentual: 0.0,
      taxa_fixa: 0.0,
      prazo_recebimento: 0,
      limite_maximo: nil,
      bandeira_cartao: nil,
      parceiro: nil,
      ativo: true,
      icone: 'cash',
      ordem: 1,
      moeda: 'BRL',
      suporte_parcelamento: false,
      numero_max_parcelas: nil,
      taxa_parcelamento: nil,
      configuracao_json: nil,
      usuario_id: nil
    },
    {
      nome: 'Cartão de Crédito',
      tipo: :credito,
      descricao: 'Pagamento com cartão de crédito',
      taxa_percentual: 2.5,
      taxa_fixa: 0.0,
      prazo_recebimento: 30,
      limite_maximo: 10000.0,
      bandeira_cartao: 'Visa',
      parceiro: 'Banco Exemplo',
      ativo: true,
      icone: 'credit-card',
      ordem: 2,
      moeda: 'BRL',
      suporte_parcelamento: true,
      numero_max_parcelas: 12,
      taxa_parcelamento: 1.5,
      configuracao_json: '{"gateway": "stripe"}',
      usuario_id: nil
    },
    {
      nome: 'Cartão de Débito',
      tipo: :debito,
      descricao: 'Pagamento com cartão de débito',
      taxa_percentual: 1.0,
      taxa_fixa: 0.5,
      prazo_recebimento: 1,
      limite_maximo: 5000.0,
      bandeira_cartao: 'Mastercard',
      parceiro: 'Banco Exemplo',
      ativo: true,
      icone: 'debit-card',
      ordem: 3,
      moeda: 'BRL',
      suporte_parcelamento: false,
      numero_max_parcelas: nil,
      taxa_parcelamento: nil,
      configuracao_json: '{"gateway": "stripe"}',
      usuario_id: nil
    },
    {
      nome: 'Pix',
      tipo: :pix,
      descricao: 'Pagamento via Pix',
      taxa_percentual: 0.0,
      taxa_fixa: 0.0,
      prazo_recebimento: 0,
      limite_maximo: nil,
      bandeira_cartao: nil,
      parceiro: nil,
      ativo: true,
      icone: 'pix',
      ordem: 4,
      moeda: 'BRL',
      suporte_parcelamento: false,
      numero_max_parcelas: nil,
      taxa_parcelamento: nil,
      configuracao_json: "{\"chave_pix\": \"#{ENV.fetch('CHAVE_PIX')}\"}",
      usuario_id: nil
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
