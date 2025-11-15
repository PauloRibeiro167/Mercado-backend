class CreateItemPedidoCompras < ActiveRecord::Migration[8.0]
  def change
    create_table :item_pedido_compras do |t|
      t.references :pedido_compra, null: false, foreign_key: true
      t.references :produto, null: false, foreign_key: true
      t.integer :quantidade
      t.decimal :preco_custo_negociado, precision: 10, scale: 2

      t.timestamps
    end
  end
end
