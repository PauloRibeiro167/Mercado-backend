require "rainbow"


# Verificar se o usuário e caixa existem
usuario = Usuario.first || Usuario.create!(
  nome: "Usuário Padrão",
  email: "seed@example.com",
  password: "123456",
  password_confirmation: "123456"
)
gerente = Usuario.second || usuario
caixa = Caixa.first || Caixa.create!(nome: "Caixa Seed", saldo: 0.0, ativo: true, usuario: usuario)

config = {
  table_name: "sessao_caixas",
  model_class: SessaoCaixa,
  singular: "sessao_caixa",
  plural: "sessao_caixas",
  recriar_env_var: "RECRIAR_SESSAO_CAIXAS",
  recriar: ENV["RECRIAR_SESSAO_CAIXAS"] == "true",
  data: [
    {
      caixa: caixa,
      usuario: usuario,               # <- adicione se belongs_to :usuario for obrigatório
      usuario_abertura: usuario,
      usuario_fechamento: nil,
      gerente_supervisor: nil,
      abertura: DateTime.now - 1.hour,
      fechamento: nil,
      valor_inicial: 0.0,
      valor_final: nil,
      saldo_esperado: nil,
      diferenca: nil,
      observacoes_abertura: "Sessão aberta para teste",
      observacoes_fechamento: nil,
      status: "aberta"
    },
    # Exemplo de sessão fechada
    {
      caixa: caixa,
      usuario: usuario,               # idem
      usuario_abertura: usuario,
      usuario_fechamento: usuario,
      gerente_supervisor: gerente,
      abertura: DateTime.now - 2.hours,
      fechamento: DateTime.now - 1.hour,
      valor_inicial: 100.0,
      valor_final: 150.0,
      saldo_esperado: 150.0,
      diferenca: 0.0,
      observacoes_abertura: "Sessão de teste fechada",
      observacoes_fechamento: "Fechamento supervisionado",
      status: "fechada"
    }
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
        # Verificar se já existe uma sessão aberta para o usuário
        if SessaoCaixa.where(usuario_abertura: record_attrs[:usuario_abertura], status: :aberta).exists?
          puts Rainbow("Sessão já aberta para o usuário #{record_attrs[:usuario_abertura].email}. Pulando criação.").yellow
          next
        end

        record = config[:model_class].new(record_attrs)
        record.save!
        criados += 1
      rescue => e
        erros_ao_criar << { config[:singular].to_sym => record_attrs[:status], erro: e.message }
        puts "Erro ao processar #{config[:singular]} '#{record_attrs[:status]}': #{e.message}"
      end
    end

    if criados == 0
      puts Rainbow("\nNenhum #{config[:singular]} novo criado, pois todos já existem").bold.yellow
    else
      puts Rainbow("\nSeed de carga de #{config[:plural]} executada com sucesso!").bold.green
    end
    puts Rainbow("Seed de carga da tabela ").bold.green + Rainbow("#{config[:table_name]} ").bold.red + Rainbow("concluída com sucesso!").bold.green
  end
rescue => e
  puts Rainbow("Erro geral na seed: #{e.message}").bold.red
end
