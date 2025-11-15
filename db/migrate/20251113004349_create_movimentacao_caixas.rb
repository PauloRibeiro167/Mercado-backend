class CreateMovimentacaoCaixas < ActiveRecord::Migration[8.0]
  def change
    create_table :movimentacao_caixas do |t|
      t.datetime :data
      t.string :descricao
      t.decimal :valor, precision: 10, scale: 2
      t.string :tipo
      t.references :conta_pagar, null: false, foreign_key: true
      t.references :conta_receber, null: false, foreign_key: true

      t.timestamps
    end
  end
end
