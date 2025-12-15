require 'rainbow'

config = {
  table_name: "Fornecedores",
  model_class: Fornecedor,
  singular: "fornecedor",
  plural: "fornecedores",
  recriar_env_var: 'RECRIAR_FORNECEDORES',
  unique_key: :cnpj,
  recriar: ENV['RECRIAR_FORNECEDORES'] == 'true',
  data: [
    {
      nome: "Fazenda Verde Ltda",
      cnpj: "12.345.678/0001-90",
      contato_nome: "João Silva",
      telefone: "(11) 99999-9999",
      telefone_contato: "(11) 88888-8888",
      email: "contato@fazendaverde.com.br",
      endereco_logradouro: "Rua das Flores",
      endereco_numero: "123",
      endereco_complemento: "Sala 1",
      endereco_bairro: "Centro",
      endereco_cidade: "São Paulo",
      endereco_estado: "SP",
      endereco_cep: "01234-567",
      lider_referencia: "Maria Oliveira",
      possui_contrato: true,
      marca_representada: "Fazenda Verde",
      usuario_email: "admin@test.com",
      responsavel_email: "gerente@test.com"
    },
    {
      nome: "Citrus Ltda",
      cnpj: "98.765.432/0001-10",
      contato_nome: "Pedro Santos",
      telefone: "(21) 77777-7777",
      telefone_contato: "(21) 66666-6666",
      email: "pedro@citrus.com.br",
      endereco_logradouro: "Av. das Laranjas",
      endereco_numero: "456",
      endereco_complemento: nil,
      endereco_bairro: "Jardim",
      endereco_cidade: "Rio de Janeiro",
      endereco_estado: "RJ",
      endereco_cep: "23456-789",
      lider_referencia: "Ana Costa",
      possui_contrato: false,
      marca_representada: "Citrus",
      usuario_email: "admin@test.com",
      responsavel_email: "gerente@test.com"
    },
    {
      nome: "Lácteos Brasil S.A.",
      cnpj: "11.222.333/0001-44",
      contato_nome: "Carlos Pereira",
      telefone: "(31) 55555-5555",
      telefone_contato: "(31) 44444-4444",
      email: "carlos@lacteosbrasil.com.br",
      endereco_logradouro: "Rua do Leite",
      endereco_numero: "789",
      endereco_complemento: "Bloco B",
      endereco_bairro: "Industrial",
      endereco_cidade: "Belo Horizonte",
      endereco_estado: "MG",
      endereco_cep: "34567-890",
      lider_referencia: "Fernanda Lima",
      possui_contrato: true,
      marca_representada: "Lácteos Brasil",
      usuario_email: "admin@test.com",
      responsavel_email: "gerente@test.com"
    }
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
        usuario = Usuario.find_or_create_by(email: record_attrs[:usuario_email])
        responsavel = Usuario.find_or_create_by(email: record_attrs[:responsavel_email])
        unless usuario && responsavel
          puts "Usuário ou responsável não encontrado para fornecedor '#{record_attrs[:nome]}'. Pulando."
          next
        end
        record_attrs_mapped = record_attrs.merge(
          usuario_id: usuario.id,
          responsavel_id: responsavel.id
        ).except(:usuario_email, :responsavel_email)
        record = config[:model_class].find_or_initialize_by(config[:unique_key] => record_attrs[config[:unique_key]])
        record.assign_attributes(record_attrs_mapped)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          atualizados += 1
        end
      rescue => e
        erros_ao_criar << { config[:singular].to_sym => record_attrs[:nome], erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:nome]}': #{e.message}"
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
