class CreateItemVendas < ActiveRecord::Migration[8.0]
  def change
    create_table :item_vendas do |t|
      t.references :venda, null: false, foreign_key: true
      t.references :lote, null: false, foreign_key: true
      t.integer :quantidade
      t.decimal :preco_unitario_vendido, precision: 10, scale: 2

      t.timestamps
    end
  end
end
