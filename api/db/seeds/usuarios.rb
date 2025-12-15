require 'rainbow'
require 'bcrypt'

config = {
  table_name: 'Usuarios',
  model_class: Usuario,
  singular: 'usuario',
  plural: 'usuarios',
  recriar_env_var: 'RECRIAR_USUARIOS',
  unique_key: :email,
  recriar: ENV['RECRIAR_USUARIOS'] == 'true',
  data: [
    { email: 'admin@test.com', senha: 'password', primeiro_nome: 'Admin', ultimo_nome: 'User', papel: :admin, status: :ativo },
    { email: 'gerente@test.com', senha: 'password', primeiro_nome: 'Gerente', ultimo_nome: 'User', papel: :usuario, status: :ativo },
    { email: 'funcionario@test.com', senha: 'password', primeiro_nome: 'Funcionario', ultimo_nome: 'User', papel: :usuario, status: :ativo },
    { email: 'ti@test.com', senha: 'password', primeiro_nome: 'TI', ultimo_nome: 'User', papel: :ti, status: :ativo },

    { email: 'administrador@test.com', senha: 'password', primeiro_nome: 'Administrador', ultimo_nome: 'Teste', papel: :admin, status: :ativo },
    { email: 'vice_gerente@test.com', senha: 'password', primeiro_nome: 'Vice', ultimo_nome: 'Gerente', papel: :usuario, status: :ativo },
    { email: 'supervisor@test.com', senha: 'password', primeiro_nome: 'Supervisor', ultimo_nome: 'Teste', papel: :usuario, status: :ativo },
    { email: 'caixa@test.com', senha: 'password', primeiro_nome: 'Caixa', ultimo_nome: 'Teste', papel: :usuario, status: :ativo },
    { email: 'atendente@test.com', senha: 'password', primeiro_nome: 'Atendente', ultimo_nome: 'Teste', papel: :usuario, status: :ativo },
    { email: 'vendedor@test.com', senha: 'password', primeiro_nome: 'Vendedor', ultimo_nome: 'Teste', papel: :usuario, status: :ativo },
    { email: 'estoquista@test.com', senha: 'password', primeiro_nome: 'Estoquista', ultimo_nome: 'Teste', papel: :usuario, status: :ativo },
    { email: 'auxiliar_limpeza@test.com', senha: 'password', primeiro_nome: 'Auxiliar', ultimo_nome: 'Limpeza', papel: :usuario, status: :ativo }
  ]
}

begin
  ActiveRecord::Base.transaction do
    if config[:recriar]
      config[:model_class].where(config[:unique_key] => config[:data].map { |r| r[config[:unique_key]] }).destroy_all
      puts Rainbow("#{config[:table_name]} existentes deletados para recriação").bold.yellow
    end

    criados = 0
    atualizados = 0
    erros_ao_criar = []
    total_antes = config[:model_class].count

    config[:data].each do |record_attrs|
      begin
        role = Role.find_by(name: record_attrs[:papel].to_s)
        unless role
          puts "Role '#{record_attrs[:papel]}' não encontrada. Pulando usuário '#{record_attrs[:email]}'."
          next
        end
        record_attrs_with_role = record_attrs.except(:papel).merge(role_id: role.id)
        record = config[:model_class].find_or_initialize_by(config[:unique_key] => record_attrs[config[:unique_key]])
        record.assign_attributes(record_attrs_with_role)

        if record.new_record?
          record.save!
          record.add_role(record_attrs[:papel].to_s)
          criados += 1
        else
          record.save!
          record.add_role(record_attrs[:papel].to_s) unless record.has_role?(record_attrs[:papel].to_s)
          atualizados += 1
        end
      rescue => e
        erros_ao_criar << { config[:singular].to_sym => record_attrs[:email], erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:email]}': #{e.message}"
      end
    end

    itens_criados = config[:model_class].count - total_antes

    if itens_criados == 0 && atualizados == 0
      puts Rainbow("\nNenhum #{config[:singular]} novo criado, pois todos já existem").bold.yellow
    else
      puts Rainbow("\nSeed de carga de #{config[:plural]} executada com sucesso!").bold.green
    end
    puts Rainbow("Seed de carga da tabela ").bold.green + Rainbow("#{config[:table_name]} ").bold.red + Rainbow("concluída com sucesso!").bold.green
  end
rescue => e
  puts Rainbow("Erro geral na seed: #{e.message}").bold.red
end
