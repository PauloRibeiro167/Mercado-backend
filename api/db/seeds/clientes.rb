require "rainbow"

# Função para gerar CPF válido fake
def generate_valid_cpf
  digits = 9.times.map { rand(10) }

  # Calcula primeiro dígito verificador
  sum = 0
  9.times { |i| sum += digits[i] * (10 - i) }
  first_verifier = (sum * 10) % 11
  first_verifier = 0 if first_verifier == 10
  digits << first_verifier

  # Calcula segundo dígito verificador
  sum = 0
  10.times { |i| sum += digits[i] * (11 - i) }
  second_verifier = (sum * 10) % 11
  second_verifier = 0 if second_verifier == 10
  digits << second_verifier

  # Formata como string
  "#{digits[0..2].join}.#{digits[3..5].join}.#{digits[6..8].join}-#{digits[9]}#{digits[10]}"
end

config = {
  table_name: "clientes",
  model_class: Cliente,
  singular: "cliente",
  plural: "clientes",
  recriar_env_var: "RECRIAR_CLIENTES",
  recriar: ENV["RECRIAR_CLIENTES"] == "true",
  data: [
    { nome: 'João Silva', cpf: generate_valid_cpf, telefone: '(11) 99999-0001', email: 'joao.silva@email.com' },
    { nome: 'Maria Oliveira', cpf: generate_valid_cpf, telefone: '(11) 99999-0002', email: 'maria.oliveira@email.com' },
    { nome: 'Carlos Santos', cpf: generate_valid_cpf, telefone: '(11) 99999-0003', email: 'carlos.santos@email.com' },
    { nome: 'Ana Costa', cpf: generate_valid_cpf, telefone: '(11) 99999-0004', email: 'ana.costa@email.com' },
    { nome: 'Pedro Lima', cpf: generate_valid_cpf, telefone: '(11) 99999-0005', email: 'pedro.lima@email.com' }
  ]
}

begin
  ActiveRecord::Base.transaction do
    if config[:recriar]
      config[:model_class].destroy_all
      puts Rainbow("#{config[:table_name]} existentes deletados para recriação").bold.yellow
    end

    criados = 0
    itens_atualizados = 0
    erros_ao_criar = []

    config[:data].each do |record_attrs|
      begin
        record = config[:model_class].find_or_initialize_by(cpf: record_attrs[:cpf])
        record.assign_attributes(record_attrs)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          itens_atualizados += 1
        end
      rescue => e
        erros_ao_criar << { item: record_attrs[:cpf], erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:cpf]}': #{e.message}"
      end
    end

    if criados == 0 && itens_atualizados == 0
      puts Rainbow("\nNenhum #{config[:singular]} novo criado, pois todos já existem").bold.yellow
    else
      puts Rainbow("\nSeed de carga de #{config[:plural]} executada com sucesso!").bold.green
    end
    puts Rainbow("Seed de carga da tabela ").bold.green + Rainbow("#{config[:table_name]} ").bold.red + Rainbow("concluída com sucesso!").bold.green
  end
rescue => e
  puts Rainbow("Erro geral na seed: #{e.message}").bold.red
end
