class CreateItemPedidoCompras < ActiveRecord::Migration[8.0]
  def change
    create_table :item_pedido_compras do |t|
      t.references :pedido_compra, null: false, foreign_key: true
      t.references :produto, null: false, foreign_key: true
      t.integer :quantidade_pedida, null: false
      t.integer :quantidade_recebida, default: 0
      t.decimal :preco_unitario, precision: 10, scale: 2, null: false
      t.decimal :subtotal, precision: 10, scale: 2
      t.decimal :desconto, precision: 10, scale: 2, default: 0
      t.date :data_validade
      t.string :numero_lote
      t.integer :status, default: 0  # 0=pendente, 1=parcialmente recebido, 2=recebido
      t.datetime :data_recebimento
      t.text :observacoes

      t.timestamps
    end
  end
end
