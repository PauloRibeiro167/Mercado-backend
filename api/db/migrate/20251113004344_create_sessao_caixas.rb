class CreateSessaoCaixas < ActiveRecord::Migration[8.0]
  def change
    create_table :sessao_caixas, comment: "Tabela para gerenciar sessões de caixas, incluindo abertura, fechamento e supervisão" do |t|
      t.references :usuario, null: false, foreign_key: true, comment: "Usuário associado à sessão"
      t.references :caixa, null: false, foreign_key: true, comment: "Caixa associada à sessão"
      t.references :usuario_abertura, null: false, foreign_key: { to_table: :usuarios }, comment: "Usuário que abriu a sessão"
      t.references :usuario_fechamento, null: true, foreign_key: { to_table: :usuarios }, comment: "Usuário que fechou a sessão"
      t.references :gerente_supervisor, null: true, foreign_key: { to_table: :usuarios }, comment: "Gerente responsável pela supervisão do fechamento"
      t.datetime :abertura, null: false, comment: "Data e hora de abertura da sessão"
      t.datetime :fechamento, null: true, comment: "Data e hora de fechamento da sessão"
      t.decimal :valor_inicial, precision: 15, scale: 2, default: 0.0, null: false, comment: "Valor inicial da sessão"
      t.decimal :valor_final, precision: 15, scale: 2, null: true, comment: "Valor final da sessão"
      t.decimal :saldo_esperado, precision: 15, scale: 2, null: true, comment: "Saldo esperado no fechamento"
      t.decimal :diferenca, precision: 15, scale: 2, null: true, comment: "Diferença entre saldo esperado e final"
      t.text :observacoes_abertura, comment: "Observações na abertura"
      t.text :observacoes_fechamento, comment: "Observações no fechamento"
      t.string :status, default: "aberta", null: false, comment: "Status da sessão (aberta, fechada, etc.)"

      t.timestamps
    end

    add_index :sessao_caixas, :status
    add_index :sessao_caixas, :abertura
    add_index :sessao_caixas, :fechamento
    add_index :sessao_caixas, [ :caixa_id, :status ]

    add_check_constraint :sessao_caixas, "valor_inicial >= 0", name: "valor_inicial_nao_negativo"
    add_check_constraint :sessao_caixas, "valor_final >= 0", name: "valor_final_nao_negativo"
    add_check_constraint :sessao_caixas, "usuario_abertura_id = usuario_fechamento_id OR fechamento IS NULL", name: "mesmo_usuario_abre_fecha_sessao"
    add_check_constraint :sessao_caixas, "status IN ('aberta', 'fechada', 'cancelada')", name: "status_valido"
  end
end
