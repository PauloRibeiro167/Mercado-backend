class CreateMovimentacaoCaixas < ActiveRecord::Migration[8.0]
  def change
    create_table :movimentacao_caixas do |t|
      t.datetime :data
      t.string :descricao
      t.decimal :valor
      t.string :tipo
      t.references :usuario, null: false, foreign_key: true
      t.references :caixa, null: false, foreign_key: true
      t.references :origem, polymorphic: true, null: true
      t.references :sessao_caixa, null: false, foreign_key: true

      t.timestamps
    end
  end
end
