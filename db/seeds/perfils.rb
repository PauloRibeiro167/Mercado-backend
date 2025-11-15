# Criar perfis de teste
perfils = [
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

perfils.each do |perfil_attrs|
  Perfil.find_or_create_by!(nome: perfil_attrs[:nome]) do |perfil|
    perfil.descricao = perfil_attrs[:descricao]
  end
end