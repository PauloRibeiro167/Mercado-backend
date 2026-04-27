require "rainbow"

# Encontrar produtos e lotes existentes
produtos = Estoque::Produto.where(nome: [ "Maçã Gala", "Banana Prata", "Laranja Bahia", "Alface Crespa" ])
lotes = Estoque::Lote.where(codigo: [ "LOTE001", "LOTE002" ])

unless produtos.count == 4 && lotes.count == 2
  puts Rainbow("Erro: Produtos ou lotes não encontrados. Execute as seeds de produtos e lotes primeiro.").bold.red
  exit
end

config = {
  table_name: "estoques",
  model_class: Estoque,
  singular: "estoque",
  plural: "estoques",
  recriar_env_var: "RECRIAR_ESTOQUES",
  recriar: ENV["RECRIAR_ESTOQUES"] == "true",
  data: [
    {
      produto_nome: "Maçã Gala",
      lote_codigo: "LOTE001",
      quantidade_atual: 100,
      quantidade_minima: 20,
      quantidade_ideal: 150
    },
    {
      produto_nome: "Banana Prata",
      lote_codigo: "LOTE002",
      quantidade_atual: 200,
      quantidade_minima: 50,
      quantidade_ideal: 300
    },
    {
      produto_nome: "Laranja Bahia",
      lote_codigo: nil,
      quantidade_atual: 80,
      quantidade_minima: 15,
      quantidade_ideal: 120
    },
    {
      produto_nome: "Alface Crespa",
      lote_codigo: nil,
      quantidade_atual: 50,
      quantidade_minima: 10,
      quantidade_ideal: 80
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
    total_antes = config[:model_class].count

    config[:data].each do |record_attrs|
      begin
        produto = Estoque::Produto.find_by(nome: record_attrs[:produto_nome])
        lote = record_attrs[:lote_codigo] ? Estoque::Lote.find_by(codigo: record_attrs[:lote_codigo]) : nil

        if produto.nil?
          puts Rainbow("Produto '#{record_attrs[:produto_nome]}' não encontrado.").bold.yellow
          next
        end

        record = config[:model_class].find_or_initialize_by(produto: produto, lote: lote)
        record.assign_attributes(
          quantidade_atual: record_attrs[:quantidade_atual],
          quantidade_minima: record_attrs[:quantidade_minima],
          quantidade_ideal: record_attrs[:quantidade_ideal]
        )

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          itens_atualizados += 1
        end
      rescue => e
        erros_ao_criar << { config[:singular].to_sym => record_attrs, erro: e.message }
        puts "Erro ao processar #{config[:singular]}: #{e.message}"
      end
    end

    itens_criados = config[:model_class].count - total_antes

    if itens_criados == 0
      puts Rainbow("\nNenhum #{config[:singular]} novo criado").bold.yellow
    else
      puts Rainbow("\n#{itens_criados} #{config[:plural]} criados ou atualizados.").bold.green
    end
    puts Rainbow("Seed de carga da tabela ").bold.green + Rainbow("#{config[:table_name]} ").bold.red + Rainbow("concluída com sucesso!").bold.green
  end
rescue => e
  puts Rainbow("Erro geral na seed: #{e.message}").bold.red
end
