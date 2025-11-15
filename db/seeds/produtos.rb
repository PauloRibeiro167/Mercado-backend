# Criar produtos
produtos = [
  # Frutas
  { nome: "Maçã Gala", descricao: "Maçã vermelha fresca", preco: 5.99, preco_custo: 3.50, quantidade_estoque: 100, unidade_medida: "kg", marca: "Fazenda Verde", categoria_nome: "Frutas" },
  { nome: "Banana Prata", descricao: "Banana madura", preco: 4.50, preco_custo: 2.80, quantidade_estoque: 150, unidade_medida: "kg", marca: "Fazenda Verde", categoria_nome: "Frutas" },
  { nome: "Laranja Bahia", descricao: "Laranja doce", preco: 3.99, preco_custo: 2.20, quantidade_estoque: 200, unidade_medida: "kg", marca: "Citrus Ltda", categoria_nome: "Frutas" },

  # Verduras
  { nome: "Alface Crespa", descricao: "Alface fresca", preco: 2.50, preco_custo: 1.50, quantidade_estoque: 80, unidade_medida: "unidade", marca: nil, categoria_nome: "Verduras" },
  { nome: "Tomate", descricao: "Tomate vermelho maduro", preco: 6.99, preco_custo: 4.00, quantidade_estoque: 120, unidade_medida: "kg", marca: nil, categoria_nome: "Verduras" },
  { nome: "Cebola", descricao: "Cebola branca", preco: 4.50, preco_custo: 2.50, quantidade_estoque: 90, unidade_medida: "kg", marca: nil, categoria_nome: "Verduras" },

  # Laticínios
  { nome: "Leite Integral", descricao: "Leite pasteurizado", preco: 4.99, preco_custo: 3.20, quantidade_estoque: 60, unidade_medida: "litro", marca: "Lácteos Brasil", categoria_nome: "Laticínios" },
  { nome: "Queijo Mussarela", descricao: "Queijo mussarela fatiado", preco: 15.99, preco_custo: 10.50, quantidade_estoque: 40, unidade_medida: "kg", marca: "Lácteos Brasil", categoria_nome: "Laticínios" },
  { nome: "Iogurte Natural", descricao: "Iogurte natural sem açúcar", preco: 3.50, preco_custo: 2.00, quantidade_estoque: 70, unidade_medida: "unidade", marca: "Yogurt Co", categoria_nome: "Laticínios" },

  # Carnes
  { nome: "Carne Bovina Alcatra", descricao: "Carne bovina de primeira", preco: 45.99, preco_custo: 30.00, quantidade_estoque: 25, unidade_medida: "kg", marca: nil, categoria_nome: "Carnes" },
  { nome: "Frango Inteiro", descricao: "Frango caipira", preco: 12.99, preco_custo: 8.50, quantidade_estoque: 30, unidade_medida: "kg", marca: "Aves Ltda", categoria_nome: "Carnes" },

  # Bebidas
  { nome: "Refrigerante Coca-Cola", descricao: "Refrigerante de cola 2L", preco: 8.99, preco_custo: 5.50, quantidade_estoque: 50, unidade_medida: "unidade", marca: "Coca-Cola", categoria_nome: "Bebidas" },
  { nome: "Suco de Laranja", descricao: "Suco natural 1L", preco: 6.50, preco_custo: 4.00, quantidade_estoque: 35, unidade_medida: "unidade", marca: "Citrus Ltda", categoria_nome: "Bebidas" }
]

produtos.each do |produto_attrs|
  categoria = Categorium.find_by(nome: produto_attrs[:categoria_nome])
  next unless categoria

  Produto.find_or_create_by!(nome: produto_attrs[:nome]) do |produto|
    produto.descricao = produto_attrs[:descricao]
    produto.preco = produto_attrs[:preco]
    produto.preco_custo = produto_attrs[:preco_custo]
    produto.quantidade_estoque = produto_attrs[:quantidade_estoque]
    produto.unidade_medida = produto_attrs[:unidade_medida]
    produto.marca = produto_attrs[:marca]
    produto.ativo = true
    produto.categoria_id = categoria.id
  end
end