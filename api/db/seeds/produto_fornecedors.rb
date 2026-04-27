require "rainbow"

config = {
  table_name: "produto_fornecedors",
  model_class: Estoque::ProdutoFornecedor,
  singular: "produto_fornecedor",
  plural: "produtos_fornecedor",
  recriar_env_var: "RECRIAR_PRODUTO_FORNECEDORS",
  recriar: ENV["RECRIAR_PRODUTO_FORNECEDORS"] == "true",
  data: [
    { produto_nome: "Maçã Gala", fornecedor_nome: "Fazenda Verde Ltda", usuario_email: "admin@test.com", preco_custo: 2.50, prazo_entrega_dias: 7, codigo_fornecedor: "MG001", ativo: true },
    { produto_nome: "Pera", fornecedor_nome: "Fazenda Verde Ltda", usuario_email: "admin@test.com", preco_custo: 3.00, prazo_entrega_dias: 7, codigo_fornecedor: "PE002", ativo: true },
    { produto_nome: "Uva", fornecedor_nome: "Fazenda Verde Ltda", usuario_email: "admin@test.com", preco_custo: 4.50, prazo_entrega_dias: 7, codigo_fornecedor: "UV003", ativo: true },
    { produto_nome: "Tomate", fornecedor_nome: "Fazenda Verde Ltda", usuario_email: "admin@test.com", preco_custo: 1.20, prazo_entrega_dias: 5, codigo_fornecedor: "TO004", ativo: true },  # Novo produto para Fazenda Verde
    { produto_nome: "Banana Prata", fornecedor_nome: "Citrus Ltda", usuario_email: "gerente@test.com", preco_custo: 1.80, prazo_entrega_dias: 5, codigo_fornecedor: "BP002", ativo: true },
    { produto_nome: "Laranja", fornecedor_nome: "Citrus Ltda", usuario_email: "gerente@test.com", preco_custo: 2.10, prazo_entrega_dias: 5, codigo_fornecedor: "LA005", ativo: true },  # Novo produto para Citrus
    { produto_nome: "Leite Integral", fornecedor_nome: "Lácteos Brasil S.A.", usuario_email: "funcionario@test.com", preco_custo: 2.20, prazo_entrega_dias: 3, codigo_fornecedor: "LI003", ativo: true },
    { produto_nome: "Queijo Mussarela", fornecedor_nome: "Lácteos Brasil S.A.", usuario_email: "funcionario@test.com", preco_custo: 5.00, prazo_entrega_dias: 4, codigo_fornecedor: "QM006", ativo: true }  # Novo produto para Lácteos
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
        produto = Estoque::Produto.find_by(nome: record_attrs[:produto_nome])
        unless produto
          erros_ao_criar << { item: "produto #{record_attrs[:produto_nome]}", erro: "Produto não encontrado" }
          puts "Erro ao processar #{config[:singular]} para produto #{record_attrs[:produto_nome]}: Produto não encontrado"
          next
        end

        fornecedor = Estoque::Fornecedor.find_by(nome: record_attrs[:fornecedor_nome])
        unless fornecedor
          erros_ao_criar << { item: "fornecedor #{record_attrs[:fornecedor_nome]}", erro: "Fornecedor não encontrado" }
          puts "Erro ao processar #{config[:singular]} para fornecedor #{record_attrs[:fornecedor_nome]}: Fornecedor não encontrado"
          next
        end

        usuario = Admin::Usuario.find_by(email: record_attrs[:usuario_email])
        unless usuario
          erros_ao_criar << { item: "usuario #{record_attrs[:usuario_email]}", erro: "Usuário não encontrado" }
          puts "Erro ao processar #{config[:singular]} para usuario #{record_attrs[:usuario_email]}: Usuário não encontrado"
          next
        end

        record_attrs_modified = record_attrs.except(:produto_nome, :fornecedor_nome, :usuario_email).merge(produto: produto, fornecedor: fornecedor, usuario: usuario)

        record = config[:model_class].find_or_initialize_by(produto: produto, fornecedor: fornecedor)
        record.assign_attributes(record_attrs_modified)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          itens_atualizados += 1
        end
      rescue => e
        erros_ao_criar << { item: "#{record_attrs[:produto_nome]}-#{record_attrs[:fornecedor_nome]}", erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:produto_nome]}-#{record_attrs[:fornecedor_nome]}': #{e.message}"
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
