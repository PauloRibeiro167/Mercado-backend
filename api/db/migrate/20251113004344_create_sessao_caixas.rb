class CreateSessaoCaixas < ActiveRecord::Migration[8.0]
  def change
    create_table :sessao_caixas, comment: "Tabela para gerenciar sessões de caixas, incluindo abertura, fechamento e supervisão" do |t|
      t.references :caixa, null: false, foreign_key: true, comment: "Caixa associada à sessão"
      t.references :usuario_abertura, foreign_key: { to_table: :usuarios }, null: false, comment: "Usuário que abriu a sessão"
      t.references :usuario_fechamento, foreign_key: { to_table: :usuarios }, null: true, comment: "Usuário que fechou a sessão"
      t.references :gerente_supervisor, foreign_key: { to_table: :usuarios }, null: true, comment: "Gerente responsável pela supervisão do fechamento"
      t.datetime :abertura, null: false, comment: "Data e hora de abertura da sessão"
      t.datetime :fechamento, null: true, comment: "Data e hora de fechamento da sessão"
      t.decimal :valor_inicial, precision: 15, scale: 2, default: 0.0, null: false, comment: "Valor inicial da sessão"
      t.decimal :valor_final, precision: 15, scale: 2, null: true, comment: "Valor final da sessão"
      t.decimal :saldo_esperado, precision: 15, scale: 2, null: true, comment: "Saldo esperado no fechamento"
      t.decimal :diferenca, precision: 15, scale: 2, null: true, comment: "Diferença entre saldo esperado e final"
      t.text :observacoes_abertura, comment: "Observações na abertura"
      t.text :observacoes_fechamento, comment: "Observações no fechamento"
      t.string :status, default: 'aberta', null: false, comment: "Status da sessão (aberta, fechada, etc.)"

      t.timestamps
    end

    # Índices para performance e consultas
    add_index :sessao_caixas, :status, comment: "Índice para filtrar por status"
    add_index :sessao_caixas, :abertura, comment: "Índice para consultas por data de abertura"
    add_index :sessao_caixas, :fechamento, comment: "Índice para consultas por data de fechamento"
    add_index :sessao_caixas, [ :caixa_id, :status ], comment: "Índice composto para caixa e status"

    # Constraints para integridade
    add_check_constraint :sessao_caixas, "valor_inicial >= 0", name: "valor_inicial_nao_negativo", comment: "Garante que o valor inicial não seja negativo"
    add_check_constraint :sessao_caixas, "valor_final >= 0", name: "valor_final_nao_negativo", comment: "Garante que o valor final não seja negativo"
    add_check_constraint :sessao_caixas, "usuario_abertura_id = usuario_fechamento_id OR fechamento IS NULL", name: "mesmo_usuario_abre_fecha_sessao", comment: "Garante que o mesmo usuário que abre a sessão deve fechá-la"
    add_check_constraint :sessao_caixas, "status IN ('aberta', 'fechada', 'cancelada')", name: "status_valido", comment: "Restringe status a valores válidos"
  end
end
