require "rainbow"

usuario = Admin::Usuario.find_by(email: "admin@test.com")

unless usuario
  puts Rainbow("Erro: Usuário não encontrado. Execute a seed de Usuario primeiro.").bold.red
  exit
end


config = {
  table_name: 'Promocoes',
  model_class: Pdv::Promocao,
  singular: 'promocao',
  plural: 'promocoes',
  recriar_env_var: 'RECRIAR_PROMOCOES',
  unique_key: :id,
  recriar: ENV['RECRIAR_PROMOCOES'] == 'true',
  data: [
    {
      produto_id: 1,
      usuario_id: usuario.id,
      tipo_promocao: 'preco_fixo',
      preco_promocional: 9.99,
      desconto_percentual: nil,
      quantidade_minima: 1,
      quantidade_gratis: 0,
      limite_usos: 100,
      ativo: true,
      prioridade: 1,
      descricao: 'Promoção de preço fixo para teste',
      data_inicio: Time.current,
      data_fim: Time.current + 30.days
    },
    {
      produto_id: 2,
      usuario_id: usuario.id,
      tipo_promocao: 'desconto_percentual',
      preco_promocional: nil,
      desconto_percentual: 20.0,
      quantidade_minima: 1,
      quantidade_gratis: 0,
      limite_usos: 50,
      ativo: true,
      prioridade: 2,
      descricao: 'Desconto percentual para teste',
      data_inicio: Time.current + 1.day,
      data_fim: Time.current + 60.days
    },
    {
      produto_id: 3,
      usuario_id: usuario.id,
      tipo_promocao: 'compre_leve',
      preco_promocional: nil,
      desconto_percentual: nil,
      quantidade_minima: 3,
      quantidade_gratis: 1,
      limite_usos: 0,
      ativo: true,
      prioridade: 3,
      descricao: 'Compre 3 leve 4 para teste',
      data_inicio: Time.current + 2.days,
      data_fim: Time.current + 90.days
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
        record = config[:model_class].find_or_initialize_by(config[:unique_key] => record_attrs[config[:unique_key]])
        record.assign_attributes(record_attrs)

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
