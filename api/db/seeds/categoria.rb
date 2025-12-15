require 'rainbow'

RECRIAR_CATEGORIAS = ENV['RECRIAR_CATEGORIAS'] == 'true'

# Adicionei campos obrigatórios e opcionais com valores padrão baseados na migração
# Assumindo que 'ordem' será definido automaticamente pelo callback do modelo se não informado
# 'categoria_pai_id' e 'criado_por_id' ficam nil (raiz e sem usuário)
# 'taxa_de_lucro' e 'imagem' ficam nil para simplicidade
# Status agora usa símbolos do enum (:disponivel, :inativo, :arquivado)
categorias = [
  { nome: "Frutas", descricao: "Frutas frescas e variadas", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Verduras", descricao: "Verduras e legumes frescos", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Carnes, Aves e Peixes", descricao: "Carnes bovinas, suínas, aves e frutos do mar", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Laticínios", descricao: "Produtos lácteos e derivados", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Padaria e Confeitaria", descricao: "Pães, bolos, doces e massas", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Mercearia e Grãos", descricao: "Arroz, feijão, massas, cereais e conservas", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Bebidas", descricao: "Refrigerantes, sucos, água e bebidas alcoólicas", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Congelados", descricao: "Produtos congelados como hortifrútis, pizzas e sorvetes", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Higiene Pessoal e Limpeza", descricao: "Produtos de higiene e limpeza doméstica", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Produtos para Bebês e Infantis", descricao: "Fraldas, leite em pó e alimentos infantis", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Snacks e Doces", descricao: "Biscoitos, chocolates e lanches diversos", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Produtos Orgânicos", descricao: "Produtos orgânicos e especiais como sem glúten ou veganos", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Artigos Diversos", descricao: "Utensílios de cozinha, papelaria e outros itens", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Cereais e Café", descricao: "Cereais matinais, café, chás e achocolatados", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Óleos e Condimentos", descricao: "Óleos, vinagres, temperos e condimentos", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Enlatados e Conservas", descricao: "Produtos enlatados, conservas e sopas", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Molhos e Temperos", descricao: "Molhos prontos, extratos e temperos", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Produtos de Limpeza", descricao: "Detergentes, desinfetantes e produtos de limpeza", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Higiene Bucal", descricao: "Cremes dentais, escovas e enxaguantes", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Cabelos e Corpo", descricao: "Shampoos, condicionadores e produtos para corpo", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Perfumaria", descricao: "Perfumes, desodorantes e cosméticos", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Cosméticos", descricao: "Maquiagem, cremes faciais e produtos de beleza", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Roupas e Acessórios", descricao: "Vestuário e acessórios pessoais", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Utilidades Domésticas", descricao: "Produtos para casa e cozinha", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Papelaria", descricao: "Materiais escolares e de escritório", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Festas e Decoração", descricao: "Artigos para festas e decoração", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Pet Shop", descricao: "Produtos para animais de estimação", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Brinquedos", descricao: "Brinquedos e jogos infantis", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Eletrodomésticos", descricao: "Aparelhos elétricos e eletrônicos", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Ferramentas", descricao: "Ferramentas manuais e elétricas", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Jardinagem", descricao: "Produtos para jardim e plantas", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Material de Construção", descricao: "Materiais para construção e reforma", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Automotivo", descricao: "Produtos para veículos e automóveis", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Esportes e Lazer", descricao: "Equipamentos esportivos e de lazer", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Música e Filmes", descricao: "CDs, DVDs e acessórios de entretenimento", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Livros e Revistas", descricao: "Livros, revistas e publicações", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 },
  { nome: "Farmácia", descricao: "Remédios, medicamentos e produtos farmacêuticos", status_da_categoria: :disponivel, excluido: false, imposto: 0.0 }
]

# Atribui taxas fictícias de lucro em pontos percentuais (inteiros) para testes
taxas_ficticias = [ 15, 20, 25, 30 ].cycle
categorias.each { |c| c[:taxa_de_lucro] = taxas_ficticias.next }

begin
  ActiveRecord::Base.transaction do
    if RECRIAR_CATEGORIAS
      Categoria.where(nome: categorias.map { |i| i[:nome] }).destroy_all
      puts Rainbow("Categorias existentes deletadas para recriação").bold.yellow
    end

    categorias_criados = 0
    categorias_atualizados = 0
    erros_ao_criar = []
    total_antes = Categoria.count

    categorias.each do |categorias_attrs|
      begin
        record = Categoria.find_or_initialize_by(nome: categorias_attrs[:nome])
        record.assign_attributes(categorias_attrs)

        if record.new_record?
          record.save!
          categorias_criados += 1
        else
          record.save!
          categorias_atualizados += 1
        end
      rescue => e
        erros_ao_criar << { categoria: categorias_attrs[:nome], erro: e.message }
        puts "Erro ao processar categoria '#{categorias_attrs[:nome]}': #{e.message}"
      end
    end

    itens_criados = Categoria.count - total_antes

    if itens_criados == 0 && categorias_atualizados == 0
      puts Rainbow("\nNenhuma categoria nova criada, pois todas já existem").bold.yellow
    else
      puts Rainbow("\nSeed de carga de categorias executada com sucesso!").bold.green
    end
    puts Rainbow("Seed de carga da tabela ").bold.green + Rainbow("Categorias ").bold.red + Rainbow("concluída com sucesso!").bold.green
  end
rescue => e
  puts Rainbow("Erro geral na seed: #{e.message}").bold.red
end
