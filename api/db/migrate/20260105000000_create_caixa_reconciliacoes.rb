class CreateCaixaReconciliacoes < ActiveRecord::Migration[8.0]
  def change
    create_table :caixa_reconciliacoes, comment: "Registra auditorias e reconciliações de caixas fiscais" do |t|
      t.references :caixa, null: false, foreign_key: true, comment: "Caixa auditado"
      t.references :usuario_responsavel, null: false, foreign_key: { to_table: :usuarios }, comment: "Usuário que executou a reconciliação"
      t.references :sessao_caixa, null: false, foreign_key: true, comment: "Sessão do caixa referente à divergência"
      t.decimal :saldo_registrado, precision: 15, scale: 2, null: false, comment: "Saldo calculado pelo sistema"
      t.decimal :saldo_fisico, precision: 15, scale: 2, null: false, comment: "Saldo encontrado fisicamente"
      t.decimal :diferenca, precision: 15, scale: 2, null: false, comment: "Saldo físico menos saldo registrado"
      t.string :motivo, null: false, comment: "Motivo resumido da reconciliação"
      t.text :observacoes, comment: "Detalhes adicionais sobre o ajuste"
      t.datetime :realizada_em, null: false, comment: "Momento em que a reconciliação foi realizada"
      t.string :status, default: "pendente", null: false, comment: "Estado do processo (pendente, aprovado, rejeitado)"

      t.timestamps
    end

    add_index :caixa_reconciliacoes, :realizada_em, comment: "Facilita consultas por período de reconciliação"
    add_index :caixa_reconciliacoes, :status
    add_index :caixa_reconciliacoes, [ :caixa_id, :realizada_em ], name: "index_reconciliacoes_on_caixa_and_realizada_em"

    add_check_constraint :caixa_reconciliacoes, "saldo_registrado >= 0", name: "saldo_registrado_nao_negativo"
    add_check_constraint :caixa_reconciliacoes, "saldo_fisico >= 0", name: "saldo_fisico_nao_negativo"
    add_check_constraint :caixa_reconciliacoes, "status IN ('pendente', 'aprovado', 'rejeitado')", name: "status_reconciliacao_valido"
  end
end
