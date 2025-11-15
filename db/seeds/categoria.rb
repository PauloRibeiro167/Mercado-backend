# Criar categorias
categorias = [
  { nome: "Frutas", descricao: "Frutas frescas e variadas" },
  { nome: "Verduras", descricao: "Verduras e legumes frescos" },
  { nome: "Carnes, Aves e Peixes", descricao: "Carnes bovinas, suínas, aves e frutos do mar" },
  { nome: "Laticínios", descricao: "Produtos lácteos e derivados" },
  { nome: "Padaria e Confeitaria", descricao: "Pães, bolos, doces e massas" },
  { nome: "Mercearia e Grãos", descricao: "Arroz, feijão, massas, cereais e conservas" },
  { nome: "Bebidas", descricao: "Refrigerantes, sucos, água e bebidas alcoólicas" },
  { nome: "Congelados", descricao: "Produtos congelados como hortifrútis, pizzas e sorvetes" },
  { nome: "Higiene Pessoal e Limpeza", descricao: "Produtos de higiene e limpeza doméstica" },
  { nome: "Produtos para Bebês e Infantis", descricao: "Fraldas, leite em pó e alimentos infantis" },
  { nome: "Snacks e Doces", descricao: "Biscoitos, chocolates e lanches diversos" },
  { nome: "Produtos Orgânicos", descricao: "Produtos orgânicos e especiais como sem glúten ou veganos" },
  { nome: "Artigos Diversos", descricao: "Utensílios de cozinha, papelaria e outros itens" },
  { nome: "Cereais e Café", descricao: "Cereais matinais, café, chás e achocolatados" },
  { nome: "Óleos e Condimentos", descricao: "Óleos, vinagres, temperos e condimentos" },
  { nome: "Enlatados e Conservas", descricao: "Produtos enlatados, conservas e sopas" },
  { nome: "Molhos e Temperos", descricao: "Molhos prontos, extratos e temperos" },
  { nome: "Produtos de Limpeza", descricao: "Detergentes, desinfetantes e produtos de limpeza" },
  { nome: "Higiene Bucal", descricao: "Cremes dentais, escovas e enxaguantes" },
  { nome: "Cabelos e Corpo", descricao: "Shampoos, condicionadores e produtos para corpo" },
  { nome: "Perfumaria", descricao: "Perfumes, desodorantes e cosméticos" },
  { nome: "Cosméticos", descricao: "Maquiagem, cremes faciais e produtos de beleza" },
  { nome: "Roupas e Acessórios", descricao: "Vestuário e acessórios pessoais" },
  { nome: "Utilidades Domésticas", descricao: "Produtos para casa e cozinha" },
  { nome: "Papelaria", descricao: "Materiais escolares e de escritório" },
  { nome: "Festas e Decoração", descricao: "Artigos para festas e decoração" },
  { nome: "Pet Shop", descricao: "Produtos para animais de estimação" },
  { nome: "Brinquedos", descricao: "Brinquedos e jogos infantis" },
  { nome: "Eletrodomésticos", descricao: "Aparelhos elétricos e eletrônicos" },
  { nome: "Ferramentas", descricao: "Ferramentas manuais e elétricas" },
  { nome: "Jardinagem", descricao: "Produtos para jardim e plantas" },
  { nome: "Material de Construção", descricao: "Materiais para construção e reforma" },
  { nome: "Automotivo", descricao: "Produtos para veículos e automóveis" },
  { nome: "Esportes e Lazer", descricao: "Equipamentos esportivos e de lazer" },
  { nome: "Música e Filmes", descricao: "CDs, DVDs e acessórios de entretenimento" },
  { nome: "Livros e Revistas", descricao: "Livros, revistas e publicações" },
  { nome: "Farmácia", descricao: "Remédios, medicamentos e produtos farmacêuticos" }
]

categorias.each do |categoria_attrs|
  Categorium.find_or_create_by!(nome: categoria_attrs[:nome]) do |categoria|
    categoria.descricao = categoria_attrs[:descricao]
  end
end