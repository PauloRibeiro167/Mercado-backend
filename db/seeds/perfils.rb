# Template genérico para seeds no projeto Mercadinho
# Este arquivo serve como base para criar novos arquivos de seeds.
# Substitua [NomeDoModelo] pelo nome do modelo (ex: Cargo, Produto).
# Substitua [itens] pelos dados a serem criados.
# Mantenha o padrão de formatação com rainbow para mensagens coloridas.

require 'rainbow'

# Seed para criar perfis no projeto Mercadinho
puts Rainbow("Iniciando seed de perfis...").blue

begin
  ActiveRecord::Base.transaction do
    puts Rainbow("Criando perfis...").blue

    # Array de dados para criar
    itens = [
      { nome: 'Admin', descricao: 'Perfil com acesso total ao sistema' },
      { nome: 'Gerente', descricao: 'Perfil para gerenciar operações do mercadinho' },
      { nome: 'Funcionário', descricao: 'Perfil básico para funcionários' },
      { nome: 'Repositor', descricao: 'Perfil para gerenciar estoque e reposição de produtos' },
      { nome: 'Caixa', descricao: 'Perfil para operar o caixa e vendas' },
      { nome: 'Subgerente', descricao: 'Perfil de subgerente com acesso intermediário' },
      { nome: 'TI', descricao: 'Perfil para equipe de tecnologia da informação' },
      { nome: 'Cliente', descricao: 'Perfil para clientes com acesso limitado' },
      { nome: 'Açougueiro', descricao: 'Responsável pelo setor de carnes' },
      { nome: 'Padaria', descricao: 'Responsável pela produção e venda de pães e doces' },
      { nome: 'Hortifruteiro', descricao: 'Responsável pelo setor de frutas, verduras e legumes' },
      { nome: 'Atendente de Balcão', descricao: 'Atendimento ao cliente em balcões específicos' },
      { nome: 'Gerente de Vendas', descricao: 'Foco em vendas e metas de vendas' },
      { nome: 'Gerente de Estoque', descricao: 'Controle de inventário e reposição' },
      { nome: 'Comprador', descricao: 'Negociações com fornecedores' },
      { nome: 'Contador', descricao: 'Gestão financeira e contábil' },
      { nome: 'Limpeza', descricao: 'Equipe de limpeza e manutenção' },
      { nome: 'Segurança', descricao: 'Vigilância e segurança do estabelecimento' },
      { nome: 'RH', descricao: 'Gestão de recursos humanos' },
      { nome: 'Marketing', descricao: 'Promoções e publicidade' },
      { nome: 'Entregador', descricao: 'Entrega de produtos aos clientes' },
      { nome: 'Estoquista', descricao: 'Organização e controle de estoque' },
      { nome: 'Supervisor de Turno', descricao: 'Supervisão durante horários específicos' }
    ]

    # Contador de itens criados
    itens_criados = 0
    total_antes = Perfil.count

    itens.each do |attrs|
      # Ajuste conforme o modelo: Perfil.find_or_create_by!(nome: attrs[:nome]) do |p|
      #   p.assign_attributes(attrs)
      # end
      Perfil.find_or_create_by!(nome: attrs[:nome]) do |p|
        p.assign_attributes(attrs)
      end
    end

    itens_criados = Perfil.count - total_antes

    puts Rainbow("#{itens_criados} perfil(is) criado(s) ou já existente(s).").green
    puts Rainbow("Seed de perfis concluída com sucesso!").green.bold
  end
rescue ActiveRecord::Rollback => e
  puts Rainbow("Transação revertida devido a erros: #{e.message}").red
rescue StandardError => e
  puts Rainbow("Erro geral durante o processamento: #{e.message}").red
end
