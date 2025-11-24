require 'rainbow'

# Seeds para ajustes de estoque
puts Rainbow("Iniciando seed de ajustes de estoque...").blue

begin
  ActiveRecord::Base.transaction do
    # Primeiro, garantir que há lotes e usuários
    # Assumindo que produtos e usuários já existem via outras seeds

    # Criar alguns lotes se não existirem
    puts Rainbow("Criando lotes necessários...").blue
    lotes_data = [
      { produto_nome: "Maçã Gala", quantidade_inicial: 100, quantidade_atual: 95, preco_custo: 3.50, data_validade: Date.today + 30.days, data_entrada: Date.today },
      { produto_nome: "Banana Prata", quantidade_inicial: 200, quantidade_atual: 180, preco_custo: 2.00, data_validade: Date.today + 15.days, data_entrada: Date.today },
      { produto_nome: "Leite Integral", quantidade_inicial: 50, quantidade_atual: 45, preco_custo: 3.00, data_validade: Date.today + 10.days, data_entrada: Date.today }
    ]

    total_lotes_antes = Lote.count
    lotes_data.each do |lote_attrs|
      produto = Produto.find_by(nome: lote_attrs[:produto_nome])
      if produto
        Lote.find_or_create_by!(produto_id: produto.id, data_entrada: lote_attrs[:data_entrada]) do |l|
          l.quantidade_inicial = lote_attrs[:quantidade_inicial]
          l.quantidade_atual = lote_attrs[:quantidade_atual]
          l.preco_custo = lote_attrs[:preco_custo]
          l.data_validade = lote_attrs[:data_validade]
        end
      else
        puts Rainbow("Aviso: Produto '#{lote_attrs[:produto_nome]}' não encontrado. Pulando lote.").yellow
      end
    end
    lotes_criados = Lote.count - total_lotes_antes

    # Agora criar ajustes de estoque
    puts Rainbow("Criando ajustes de estoque...").blue
    ajustes = [
      { lote_produto_nome: "Maçã Gala", usuario_email: "admin@test.com", tipo: "entrada", quantidade: 10, motivo: "Recebimento de mercadoria" },
      { lote_produto_nome: "Banana Prata", usuario_email: "gerente@test.com", tipo: "saida", quantidade: 20, motivo: "Ajuste por perda" },
      { lote_produto_nome: "Leite Integral", usuario_email: "funcionario@test.com", tipo: "entrada", quantidade: 5, motivo: "Correção de inventário" }
    ]

    total_ajustes_antes = AjusteEstoque.count
    ajustes.each do |ajuste_attrs|
      lote = Lote.joins(:produto).find_by(produtos: { nome: ajuste_attrs[:lote_produto_nome] })
      usuario = Usuario.find_by(email: ajuste_attrs[:usuario_email])
      if lote && usuario
        AjusteEstoque.find_or_create_by!(lote_id: lote.id, usuario_id: usuario.id, tipo: ajuste_attrs[:tipo], quantidade: ajuste_attrs[:quantidade]) do |a|
          a.motivo = ajuste_attrs[:motivo]
        end
      else
        puts Rainbow("Aviso: Lote para produto '#{ajuste_attrs[:lote_produto_nome]}' ou usuário '#{ajuste_attrs[:usuario_email]}' não encontrado. Pulando ajuste.").yellow
      end
    end
    ajustes_criados = AjusteEstoque.count - total_ajustes_antes

    puts Rainbow("#{lotes_criados} lote(s) criado(s) ou já existente(s).").green
    puts Rainbow("#{ajustes_criados} ajuste(s) de estoque criado(s) ou já existente(s).").green
    puts Rainbow("Seed de ajustes de estoque concluída com sucesso!").green.bold
  end
rescue ActiveRecord::Rollback => e
  puts Rainbow("Transação revertida devido a erros: #{e.message}").red
rescue StandardError => e
  puts Rainbow("Erro geral durante o processamento: #{e.message}").red
end
