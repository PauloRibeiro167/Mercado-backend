class CreateCaixas < ActiveRecord::Migration[8.0]
  def change
    create_table :caixas, comment: "Tabela para gerenciar caixas registradoras, incluindo saldo e status de operação" do |t|
      t.string :nome, null: false, comment: "Nome identificador da caixa"
      t.decimal :saldo, precision: 15, scale: 2, default: 0.0, null: false, comment: "Saldo atual da caixa em reais"
      t.boolean :ativo, default: true, null: false, comment: "Indica se a caixa está ativa"
      t.date :data_abertura, default: -> { 'CURRENT_DATE' }, comment: "Data de abertura da caixa"
      t.references :usuario, foreign_key: true, null: true, comment: "Usuário responsável pela criação da caixa"

      t.timestamps
    end

    # Índices para auditabilidade e performance
    add_index :caixas, :nome, unique: true, comment: "Índice único para garantir nomes únicos"
    add_index :caixas, :ativo, comment: "Índice para filtrar caixas ativas/inativas"
    add_index :caixas, :data_abertura, comment: "Índice para consultas por data de abertura"

    # Constraints adicionais para auditabilidade
    add_check_constraint :caixas, "saldo >= 0", name: "saldo_nao_negativo", comment: "Garante que o saldo não seja negativo"
    add_check_constraint :caixas, "data_abertura <= CURRENT_DATE", name: "data_abertura_nao_futura", comment: "Impede datas de abertura no futuro"
  end
end
