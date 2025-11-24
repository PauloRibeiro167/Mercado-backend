# Criar produtos
produtos = [
  # Frutas
  { nome: "Maçã Gala", descricao: "Maçã vermelha fresca", preco: 5.99, unidade_medida: "kg", marca: "Fazenda Verde", categoria_nome: "Frutas" },
  { nome: "Banana Prata", descricao: "Banana madura", preco: 4.50, unidade_medida: "kg", marca: "Fazenda Verde", categoria_nome: "Frutas" },
  { nome: "Laranja Bahia", descricao: "Laranja doce", preco: 3.99, unidade_medida: "kg", marca: "Citrus Ltda", categoria_nome: "Frutas" },

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

produtos.each do |produto_attrs|
  categoria = Categorium.find_by(nome: produto_attrs[:categoria_nome])
  if categoria.nil?
    puts "Erro: Categoria '#{produto_attrs[:categoria_nome]}' não encontrada para produto '#{produto_attrs[:nome]}'."
    next
  end

  produto = Produto.find_by(nome: produto_attrs[:nome])
  if produto
    puts "Produto '#{produto_attrs[:nome]}' já existe."
  else
    begin
      produto = Produto.create!(
        nome: produto_attrs[:nome],
        descricao: produto_attrs[:descricao],
        preco: produto_attrs[:preco],
        unidade_medida: produto_attrs[:unidade_medida],
        marca: produto_attrs[:marca],
        ativo: true,
        categoria_id: categoria.id
      )
      puts "Produto '#{produto.nome}' criado com sucesso."
    rescue => e
      puts "Erro ao criar produto '#{produto_attrs[:nome]}': #{e.message}"
    end
  end
end
