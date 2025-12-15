require 'rainbow'

RECRIAR_PRODUTOS = ENV['RECRIAR_PRODUTOS'] == 'true'

produtos = [
  # Frutas
  { nome: "Maçã Gala", descricao: "Maçã vermelha fresca", preco: 5.99, unidade_medida: "kg", marca: "Fazenda Verde", categoria_nome: "Frutas" },
  { nome: "Banana Prata", descricao: "Banana madura", preco: 4.50, unidade_medida: "kg", marca: "Fazenda Verde", categoria_nome: "Frutas" },
  { nome: "Laranja Bahia", descricao: "Laranja doce", preco: 3.99, unidade_medida: "kg", marca: "Citrus Ltda", categoria_nome: "Frutas" },
  { nome: "Laranja", descricao: "Laranja doce", preco: 3.99, unidade_medida: "kg", marca: "Citrus Ltda", categoria_nome: "Frutas" },  # Novo produto
  { nome: "Pera", descricao: "Pera fresca", preco: 6.50, unidade_medida: "kg", marca: "Fazenda Verde", categoria_nome: "Frutas" },
  { nome: "Uva", descricao: "Uva sem semente", preco: 8.99, unidade_medida: "kg", marca: "Fazenda Verde", categoria_nome: "Frutas" },

  # Verduras
  { nome: "Alface Crespa", descricao: "Alface fresca", preco: 2.50, unidade_medida: "unidade", marca: nil, categoria_nome: "Verduras" },
  { nome: "Tomate", descricao: "Tomate vermelho maduro", preco: 6.99, unidade_medida: "kg", marca: nil, categoria_nome: "Verduras" },
  { nome: "Cebola", descricao: "Cebola branca", preco: 4.50, unidade_medida: "kg", marca: nil, categoria_nome: "Verduras" },

  # Laticínios
  { nome: "Leite Integral", descricao: "Leite pasteurizado", preco: 4.99, unidade_medida: "litro", marca: "Lácteos Brasil", categoria_nome: "Laticínios" },
  { nome: "Queijo Mussarela", descricao: "Queijo mussarela fatiado", preco: 15.99, unidade_medida: "kg", marca: "Lácteos Brasil", categoria_nome: "Laticínios" },
  { nome: "Iogurte Natural", descricao: "Iogurte natural sem açúcar", preco: 3.50, unidade_medida: "unidade", marca: "Yogurt Co", categoria_nome: "Laticínios" },

  # Carnes
  { nome: "Carne Bovina Alcatra", descricao: "Carne bovina de primeira", preco: 45.99, unidade_medida: "kg", marca: nil, categoria_nome: "Carnes, Aves e Peixes" },
  { nome: "Frango Inteiro", descricao: "Frango caipira", preco: 12.99, unidade_medida: "kg", marca: "Aves Ltda", categoria_nome: "Carnes, Aves e Peixes" },

  # Bebidas
  { nome: "Refrigerante Coca-Cola", descricao: "Refrigerante de cola 2L", preco: 8.99, unidade_medida: "unidade", marca: "Coca-Cola", categoria_nome: "Bebidas" },
  { nome: "Suco de Laranja", descricao: "Suco natural 1L", preco: 6.50, unidade_medida: "unidade", marca: "Citrus Ltda", categoria_nome: "Bebidas" }
]

begin
  ActiveRecord::Base.transaction do
    if RECRIAR_PRODUTOS
      Produto.where(nome: produtos.map { |p| p[:nome] }).destroy_all  # Corrigido para Produto
      puts Rainbow("Produtos existentes deletados para recriação").bold.yellow
    end

    produtos_criados = 0
    produtos_atualizados = 0
    erros_ao_criar = []
    total_antes = Produto.count

    produtos.each do |produto_attrs|
      begin
        categoria = Categoria.find_or_create_by!(nome: produto_attrs[:categoria_nome])

        produto = Produto.find_or_initialize_by(nome: produto_attrs[:nome])
        produto.assign_attributes(
          descricao: produto_attrs[:descricao],
          preco: produto_attrs[:preco],
          unidade_medida: produto_attrs[:unidade_medida],
          marca: produto_attrs[:marca],
          ativo: true,
          categoria_id: categoria.id
        )

        if produto.new_record?
          produto.save!
          produtos_criados += 1
        else
          produto.save!
          produtos_atualizados += 1
        end
      rescue => e
        erros_ao_criar << { produto: produto_attrs[:nome], erro: e.message }
        puts "Erro ao processar produto '#{produto_attrs[:nome]}': #{e.message}"
      end
    end

    itens_criados = Produto.count - total_antes
    if itens_criados == 0 && itens_atualizados == 0
      puts Rainbow("\nnenhum cargo novo criado, pois todos já exitem").bold.yellow
    else
      puts Rainbow("\nSeed de carga de Produtos executada com sucesso!").bold.green
    end
    puts Rainbow("Seed de carga da tabela ").bold.green + Rainbow("Produtos ").bold.red + Rainbow("concluída com sucesso!").bold.green
  end
rescue => e
  puts Rainbow("Erro geral na seed: #{e.message}").bold.red
end
