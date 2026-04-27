require 'rainbow'

RECRIAR_USUARIOS_PERFIS = ENV['RECRIAR_USUARIOS_PERFIS'] == 'true'


config = {
  table_name: 'UsuarioPerfils',
  model_class: Admin::UsuarioPerfil,
  singular: 'usuario_perfil',
  plural: 'usuario_perfils',
  recriar_env_var: 'RECRIAR_USUARIOS_PERFIS',
  unique_key: [ :usuario_email, :perfil_nome ],
  data: [
    { usuario_email: 'admin@test.com', perfil_nome: 'Admin' },
    { usuario_email: 'gerente@test.com', perfil_nome: 'Gerente' },
    { usuario_email: 'funcionario@test.com', perfil_nome: 'Funcionário' },
    { usuario_email: 'ti@test.com', perfil_nome: 'TI' },
    { usuario_email: 'administrador@test.com', perfil_nome: 'Admin' },
    { usuario_email: 'vice_gerente@test.com', perfil_nome: 'Subgerente' },
    { usuario_email: 'supervisor@test.com', perfil_nome: 'Supervisor de Turno' },
    { usuario_email: 'caixa@test.com', perfil_nome: 'Caixa' },
    { usuario_email: 'atendente@test.com', perfil_nome: 'Atendente de Balcão' },
    { usuario_email: 'vendedor@test.com', perfil_nome: 'Estoquista' },
    { usuario_email: 'estoquista@test.com', perfil_nome: 'Estoquista' },
    { usuario_email: 'auxiliar_limpeza@test.com', perfil_nome: 'Limpeza' }
  ]
}


begin
  ActiveRecord::Base.transaction do
    if ENV[config[:recriar_env_var]] == 'true'
      config[:model_class].destroy_all
      puts Rainbow("#{config[:table_name]} existentes deletados para recriação").bold.yellow
    end

      criados = 0
      atualizados = 0
      erros_ao_criar = []
      total_antes = config[:model_class].count

    config[:data].each do |record_attrs|
      begin
        usuario = Admin::Usuario.find_by(email: record_attrs[:usuario_email])
        perfil = Admin::Perfil.find_by(nome: record_attrs[:perfil_nome])

        if usuario.nil?
          raise "Usuário com email '#{record_attrs[:usuario_email]}' não encontrado"
        end
        if perfil.nil?
          raise "Perfil com nome '#{record_attrs[:perfil_nome]}' não encontrado"
        end

        record = config[:model_class].find_or_initialize_by(usuario: usuario, perfil: perfil)

        if record.new_record?
          record.save!
          criados += 1
        else
          atualizados += 1
        end
      rescue => e
        erros_ao_criar << { config[:singular].to_sym => record_attrs[config[:unique_key][0]], erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[config[:unique_key][0]]}': #{e.message}"
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
