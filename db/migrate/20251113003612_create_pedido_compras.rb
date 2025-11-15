class CreatePedidoCompras < ActiveRecord::Migration[8.0]
  def change
    create_table :pedido_compras do |t|
      t.references :fornecedor, null: false, foreign_key: true
      t.date :data_pedido
      t.string :status
      t.decimal :valor_total, precision: 10, scale: 2

      t.timestamps
    end
  end
end
