require "rainbow"

config = {
  table_name: "Lotes",
  model_class: Lote,
  singular: "lote",
  plural: "lotes",
  recriar_env_var: "RECRIAR_LOTES",
  unique_key: :codigo,
  recriar: ENV["RECRIAR_LOTES"] == "true",
  data: [
    {
      codigo: "LOTE001",
      produto_nome: "Maçã Gala",
      quantidade_atual: 100,
      quantidade_inicial: 100,
      preco_custo: 4.50,
      data_validade: Date.today + 6.months,
      data_entrada: Date.today - 10.days,
      controle_de_validade: true
    },
    {
      codigo: "LOTE002",
      produto_nome: "Banana Prata",
      quantidade_atual: 200,
      quantidade_inicial: 200,
      preco_custo: 3.00,
      data_validade: Date.today + 12.months,
      data_entrada: Date.today - 5.days,
      controle_de_validade: true
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
    atualizados = 0
    erros_ao_criar = []
    total_antes = config[:model_class].count

    config[:data].each do |record_attrs|
      begin
        produto = Produto.find_by(nome: record_attrs[:produto_nome])
        if produto.nil?
          puts Rainbow("Produto '#{record_attrs[:produto_nome]}' não encontrado. Pulando lote '#{record_attrs[:codigo]}'.").bold.yellow
          next
        end

        record_attrs[:produto_id] = produto.id
        record_attrs.delete(:produto_nome)

        record = config[:model_class].find_or_initialize_by(config[:unique_key] => record_attrs[config[:unique_key]])
        record.assign_attributes(record_attrs)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          atualizados += 1
        end
      rescue => e
        erros_ao_criar << { config[:singular].to_sym => record_attrs[:codigo], erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:codigo]}': #{e.message}"
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
