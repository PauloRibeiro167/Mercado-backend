require 'rainbow'

config = {
  table_name: 'funcionarios',
  model_class: Funcionario,
  singular: 'funcionario',
  plural: 'funcionarios',
  recriar_env_var: 'RECRIAR_FUNCIONARIOS',
  unique_key: :cpf,
  data: [
    {
      nome: 'Funcionário Exemplo',
      cpf: '123.456.789-00',
      telefone: '(11) 99999-0001',
      email: 'funcionario@test.com',
      data_nascimento: Date.new(1990, 1, 1),
      data_admissao: Date.new(2020, 1, 1),
      cargo_nome: 'Vendedor',
      usuario_email: 'funcionario@test.com',
      salario: 2500.00,
      tipos_contrato_nome: 'fixo',
      ativo: true
    },
    {
      nome: 'Gerente Exemplo',
      cpf: '987.654.321-00',
      telefone: '(11) 99999-0002',
      email: 'gerente@test.com',
      data_nascimento: Date.new(1985, 5, 15),
      data_admissao: Date.new(2020, 1, 1),
      cargo_nome: 'Gerente',
      usuario_email: 'gerente@test.com',
      salario: 4000.00,
      tipos_contrato_nome: 'fixo',
      ativo: true
    },
    {
      nome: 'Administrador Teste',
      cpf: '111.222.333-44',
      telefone: '(11) 99999-0003',
      email: 'administrador@test.com',
      data_nascimento: Date.new(1980, 10, 20),
      data_admissao: Date.new(2020, 1, 1),
      cargo_nome: 'Administrador',
      usuario_email: 'administrador@test.com',
      salario: 5000.00,
      tipos_contrato_nome: 'fixo',
      ativo: true
    },
    {
      nome: 'Vice Gerente Teste',
      cpf: '222.333.444-55',
      telefone: '(11) 99999-0004',
      email: 'vice_gerente@test.com',
      data_nascimento: Date.new(1988, 3, 10),
      data_admissao: Date.new(2020, 1, 1),
      cargo_nome: 'Vice Gerente',
      usuario_email: 'vice_gerente@test.com',
      salario: 3500.00,
      tipos_contrato_nome: 'fixo',
      ativo: true
    },
    {
      nome: 'Supervisor Teste',
      cpf: '333.444.555-66',
      telefone: '(11) 99999-0005',
      email: 'supervisor@test.com',
      data_nascimento: Date.new(1992, 7, 25),
      data_admissao: Date.new(2020, 1, 1),
      cargo_nome: 'Supervisor',
      usuario_email: 'supervisor@test.com',
      salario: 3000.00,
      tipos_contrato_nome: 'fixo',
      ativo: true
    },
    {
      nome: 'Caixa Teste',
      cpf: '444.555.666-77',
      telefone: '(11) 99999-0006',
      email: 'caixa@test.com',
      data_nascimento: Date.new(1995, 12, 5),
      data_admissao: Date.new(2020, 1, 1),
      cargo_nome: 'Caixa',
      usuario_email: 'caixa@test.com',
      salario: 2200.00,
      tipos_contrato_nome: 'fixo',
      ativo: true
    },
    {
      nome: 'Atendente Teste',
      cpf: '555.666.777-88',
      telefone: '(11) 99999-0007',
      email: 'atendente@test.com',
      data_nascimento: Date.new(1993, 4, 18),
      data_admissao: Date.new(2020, 1, 1),
      cargo_nome: 'Atendente',
      usuario_email: 'atendente@test.com',
      salario: 2000.00,
      tipos_contrato_nome: 'fixo',
      ativo: true
    },
    {
      nome: 'Vendedor Teste',
      cpf: '666.777.888-99',
      telefone: '(11) 99999-0008',
      email: 'vendedor@test.com',
      data_nascimento: Date.new(1991, 9, 30),
      data_admissao: Date.new(2020, 1, 1),
      cargo_nome: 'Vendedor',
      usuario_email: 'vendedor@test.com',
      salario: 2500.00,
      tipos_contrato_nome: 'fixo',
      ativo: true
    },
    {
      nome: 'Estoquista Teste',
      cpf: '777.888.999-00',
      telefone: '(11) 99999-0009',
      email: 'estoquista@test.com',
      data_nascimento: Date.new(1987, 11, 12),
      data_admissao: Date.new(2020, 1, 1),
      cargo_nome: 'Estoquista',
      usuario_email: 'estoquista@test.com',
      salario: 2300.00,
      tipos_contrato_nome: 'fixo',
      ativo: true
    },
    {
      nome: 'Auxiliar de Limpeza Teste',
      cpf: '888.999.000-11',
      telefone: '(11) 99999-0010',
      email: 'auxiliar_limpeza@test.com',
      data_nascimento: Date.new(1994, 6, 8),
      data_admissao: Date.new(2020, 1, 1),
      cargo_nome: 'Auxiliar de Limpeza',
      usuario_email: 'auxiliar_limpeza@test.com',
      salario: 1800.00,
      tipos_contrato_nome: 'fixo',
      ativo: true
    }
  ]
}

begin
  ActiveRecord::Base.transaction do
    if ENV[config[:recriar_env_var]] == 'true'
      config[:model_class].where(config[:unique_key] => config[:data].map { |r| r[config[:unique_key]] }).destroy_all
      puts Rainbow("#{config[:table_name]} existentes deletados para recriação").bold.yellow
    end

    criados = 0
    atualizados = 0
    erros_ao_criar = []
    total_antes = config[:model_class].count

    config[:data].each do |record_attrs|
      begin
        cargo = Cargo.find_by(nome: record_attrs[:cargo_nome].to_s)
        unless cargo
          puts "Cargo '#{record_attrs[:cargo_nome]}' não encontrado. Pulando funcionário '#{record_attrs[:cpf]}'."
          next
        end

        usuario = Usuario.find_by(email: record_attrs[:usuario_email])
        unless usuario
          puts "Usuario com email '#{record_attrs[:usuario_email]}' não encontrado. Pulando funcionário '#{record_attrs[:cpf]}'."
          next
        end

        begin
          tipo_contrato = TiposContrato.find_or_create_by(nome: record_attrs[:tipos_contrato_nome])
        rescue NameError => e
          puts "Erro: Classe TiposContrato não encontrada. Verifique se o arquivo do modelo 'tipos_contrato.rb' existe e define a classe corretamente."
          raise
        rescue => e
          puts "Erro ao buscar/criar TipoContrato '#{record_attrs[:tipos_contrato_nome]}': #{e.message}. Verifique se a tabela 'tipos_contratos' existe e tem dados."
          next
        end

        record_attrs_with_associations = record_attrs.except(:cargo_nome, :usuario_email, :tipos_contrato_nome).merge(cargo_id: cargo.id, usuario_id: usuario.id, tipos_contrato_id: tipo_contrato.id)  # Correção: plural
        record = config[:model_class].find_or_initialize_by(config[:unique_key] => record_attrs[config[:unique_key]])
        record.assign_attributes(record_attrs_with_associations)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          atualizados += 1
        end
      rescue ActiveRecord::RecordInvalid => e
        erros_ao_criar << { config[:singular].to_sym => record_attrs[:cpf], erro: e.message }
        puts "Erro de validação ao processar #{config[:singular]} '#{record_attrs[:cpf]}': #{e.message}"
      rescue => e
        erros_ao_criar << { config[:singular].to_sym => record_attrs[:cpf], erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:cpf]}': #{e.message}"
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
