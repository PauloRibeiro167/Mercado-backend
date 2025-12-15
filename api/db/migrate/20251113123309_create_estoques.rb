class CreateEstoques < ActiveRecord::Migration[8.0]
  def change
    create_table :estoques do |t|
      t.references :produto, null: false, foreign_key: true
      t.references :lote, null: true, foreign_key: true
      t.integer :quantidade_atual, null: false, default: 0
      t.integer :quantidade_minima, default: 0
      t.integer :quantidade_ideal, default: 0
      t.decimal :media_vendas_diarias, precision: 5, scale: 2, default: 0.0
      t.string :localizacao
      t.datetime :ultima_atualizacao

      t.timestamps
    end

    add_index :estoques, [ :produto_id, :lote_id ], unique: true
    add_index :estoques, :quantidade_atual
  end
end
