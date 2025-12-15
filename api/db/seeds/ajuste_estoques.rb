require "rainbow"

config = {
  table_name: "ajuste_estoques",
  model_class: AjusteEstoque,
  singular: "ajuste_estoque",
  plural: "ajustes de estoque",
  recriar_env_var: "RECRIAR_AJUSTE_ESTOQUES",
  recriar: ENV["RECRIAR_AJUSTE_ESTOQUES"] == "true",
  data: [
    { lote_produto_nome: "Maçã Gala", usuario_email: "admin@test.com", tipo: "entrada", quantidade: 10, motivo: "Recebimento de mercadoria" },
    { lote_produto_nome: "Banana Prata", usuario_email: "gerente@test.com", tipo: "saida", quantidade: 20, motivo: "Ajuste por perda" },
    { lote_produto_nome: "Leite Integral", usuario_email: "funcionario@test.com", tipo: "entrada", quantidade: 5, motivo: "Correção de inventário" },
    { lote_produto_nome: "Maçã Gala", usuario_email: "gerente@test.com", tipo: "saida", quantidade: 5, motivo: "Venda não registrada" },
    { lote_produto_nome: "Banana Prata", usuario_email: "admin@test.com", tipo: "entrada", quantidade: 15, motivo: "Reabastecimento" },
    { lote_produto_nome: "Leite Integral", usuario_email: "funcionario@test.com", tipo: "saida", quantidade: 2, motivo: "Quebra de produto" },
    { lote_produto_nome: "Maçã Gala", usuario_email: "funcionario@test.com", tipo: "entrada", quantidade: 8, motivo: "Devolução de cliente" },
    { lote_produto_nome: "Banana Prata", usuario_email: "gerente@test.com", tipo: "saida", quantidade: 10, motivo: "Ajuste de contagem" },
    { lote_produto_nome: "Leite Integral", usuario_email: "admin@test.com", tipo: "entrada", quantidade: 12, motivo: "Compra adicional" },
    { lote_produto_nome: "Maçã Gala", usuario_email: "gerente@test.com", tipo: "saida", quantidade: 3, motivo: "Perda por vencimento" }
  ]
}

begin
  ActiveRecord::Base.transaction do
    lotes_data = [
      { produto_nome: "Maçã Gala", codigo: "LOTE001", quantidade_inicial: 100, quantidade_atual: 95, preco_custo: 3.50, data_validade: Date.today + 30.days, data_entrada: Date.today },
      { produto_nome: "Banana Prata", codigo: "LOTE002", quantidade_inicial: 200, quantidade_atual: 180, preco_custo: 2.00, data_validade: Date.today + 15.days, data_entrada: Date.today },
      { produto_nome: "Leite Integral", codigo: "LOTE003", quantidade_inicial: 50, quantidade_atual: 45, preco_custo: 3.00, data_validade: Date.today + 10.days, data_entrada: Date.today }
    ]

    total_lotes_antes = Lote.count
    lotes_data.each do |lote_attrs|
      produto = Produto.find_by(nome: lote_attrs[:produto_nome])
      if produto
        Lote.find_or_create_by!(codigo: lote_attrs[:codigo]) do |l|
          l.produto_id = produto.id
          l.quantidade_inicial = lote_attrs[:quantidade_inicial]
          l.quantidade_atual = lote_attrs[:quantidade_atual]
          l.preco_custo = lote_attrs[:preco_custo]
          l.data_validade = lote_attrs[:data_validade]
          l.data_entrada = lote_attrs[:data_entrada]
        end
      else
        puts Rainbow("Aviso: Produto '#{lote_attrs[:produto_nome]}' não encontrado. Pulando lote.").yellow
      end
    end
    lotes_criados = Lote.count - total_lotes_antes

    if config[:recriar]
      config[:model_class].destroy_all
      puts Rainbow("#{config[:table_name]} existentes deletados para recriação").bold.yellow
    end

    criados = 0
    itens_atualizados = 0
    erros_ao_criar = []

    config[:data].each do |record_attrs|
      begin
        lote = Lote.joins(:produto).find_by(produtos: { nome: record_attrs[:lote_produto_nome] })
        unless lote
          erros_ao_criar << { item: "lote #{record_attrs[:lote_produto_nome]}", erro: "Lote não encontrado" }
          puts "Erro ao processar #{config[:singular]} para lote #{record_attrs[:lote_produto_nome]}: Lote não encontrado"
          next
        end

        usuario = Usuario.find_by(email: record_attrs[:usuario_email])
        unless usuario
          erros_ao_criar << { item: "usuario #{record_attrs[:usuario_email]}", erro: "Usuário não encontrado" }
          puts "Erro ao processar #{config[:singular]} para usuario #{record_attrs[:usuario_email]}: Usuário não encontrado"
          next
        end

        record_attrs_modified = record_attrs.except(:lote_produto_nome, :usuario_email).merge(lote: lote, usuario: usuario)

        record = config[:model_class].find_or_initialize_by(lote: lote, usuario: usuario, tipo: record_attrs[:tipo], quantidade: record_attrs[:quantidade])
        record.assign_attributes(record_attrs_modified)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          itens_atualizados += 1
        end
      rescue => e
        erros_ao_criar << { item: "#{record_attrs[:lote_produto_nome]}-#{record_attrs[:usuario_email]}", erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:lote_produto_nome]}-#{record_attrs[:usuario_email]}': #{e.message}"
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
