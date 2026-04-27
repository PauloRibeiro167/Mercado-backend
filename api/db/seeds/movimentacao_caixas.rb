require "rainbow"

# Verificar dependências
usuario = Admin::Usuario.first
caixa = Pdv::Caixa.first
sessao_caixa = Pdv::SessaoCaixa.first

unless usuario && caixa && sessao_caixa
  puts Rainbow("Erro: Usuário, caixa ou sessão de caixa não encontrados. Execute as seeds anteriores primeiro.").bold.red
  exit
end

config = {
  table_name: "movimentacao_caixas",
  model_class: Pdv::MovimentacaoCaixa,
  singular: "movimentacao_caixa",
  plural: "movimentacao_caixas",
  recriar_env_var: "RECRIAR_MOVIMENTACAO_CAIXAS",
  recriar: ENV["RECRIAR_MOVIMENTACAO_CAIXAS"] == "true",
  data: [
    {
      data: DateTime.now - 2.days,
      descricao: "Entrada de venda - Produto X",
      valor: 150.00,
      tipo: "entrada",
      usuario: usuario,
      caixa: caixa,
      sessao_caixa: sessao_caixa,
      origem_type: nil,
      origem_id: nil
    },
    {
      data: DateTime.now - 1.day,
      descricao: "Saída para pagamento de fornecedor",
      valor: 100.00,
      tipo: "saida",
      usuario: usuario,
      caixa: caixa,
      sessao_caixa: sessao_caixa,
      origem_type: nil,
      origem_id: nil
    },
    {
      data: DateTime.now,
      descricao: "Entrada de depósito bancário",
      valor: 500.00,
      tipo: "entrada",
      usuario: usuario,
      caixa: caixa,
      sessao_caixa: sessao_caixa,
      origem_type: nil,
      origem_id: nil
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
        record = config[:model_class].find_or_initialize_by(data: record_attrs[:data], descricao: record_attrs[:descricao])
        record.assign_attributes(record_attrs)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          itens_atualizados += 1
        end
      rescue => e
        erros_ao_criar << { config[:singular].to_sym => record_attrs[:descricao], erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:descricao]}': #{e.message}"
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
