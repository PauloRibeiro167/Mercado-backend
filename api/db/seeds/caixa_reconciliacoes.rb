require "rainbow"

caixa = Caixa.first
responsavel = Usuario.first
sessao = SessaoCaixa.where(caixa: caixa).first

unless caixa && responsavel && sessao
  puts Rainbow("Erro: Caixa, usuário responsável ou sessão compatível não encontrados. Execute as seeds básicas primeiro.").bold.red
  exit
end

config = {
  table_name: "caixa_reconciliacoes",
  model_class: CaixaReconciliacao,
  singular: "caixa_reconciliacao",
  plural: "caixa_reconciliacoes",
  recriar_env_var: "RECRIAR_CAIXA_RECONCILIACOES",
  recriar: ENV["RECRIAR_CAIXA_RECONCILIACOES"] == "true",
  data: [
    {
      caixa: caixa,
      usuario_responsavel: responsavel,
      sessao_caixa: sessao,
      saldo_registrado: 500.00,
      saldo_fisico: 495.00,
      diferenca: -5.00,
      motivo: :divergencia_contagem,
      observacoes: "Reconciliação realizada após fechamento com diferença negativa de R$5,00.",
      realizada_em: Time.current - 1.day,
      status: "aprovado"
    },
    {
      caixa: caixa,
      usuario_responsavel: responsavel,
      sessao_caixa: sessao,
      saldo_registrado: 750.00,
      saldo_fisico: 760.00,
      diferenca: 10.00,
      motivo: :deposito_nao_registrado,
      observacoes: "Caixa apresentou R$10,00 a mais devido a depósito não lançado no sistema.",
      realizada_em: Time.current,
      status: "pendente"
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

    config[:data].each do |record_attrs|
      begin
        record = config[:model_class].find_or_initialize_by(
          caixa: record_attrs[:caixa],
          realizada_em: record_attrs[:realizada_em]
        )
        record.assign_attributes(record_attrs)

        if record.new_record?
          record.save!
          criados += 1
        else
          record.save!
          itens_atualizados += 1
        end
      rescue => e
        puts "Erro ao processar #{config[:singular]} em #{record_attrs[:realizada_em]}: #{e.message}"
      end
    end

    if criados.zero? && itens_atualizados.zero?
      puts Rainbow("\nNenhuma #{config[:singular]} nova criada, pois todos os registros já existem").bold.yellow
    else
      puts Rainbow("\nSeed de carga de #{config[:plural]} executada com sucesso!").bold.green
    end

    puts Rainbow("Seed de carga da tabela ").bold.green +
         Rainbow("#{config[:table_name]} ").bold.red +
         Rainbow("concluída com sucesso!").bold.green
  end
rescue => e
  puts Rainbow("Erro geral na seed: #{e.message}").bold.red
end
