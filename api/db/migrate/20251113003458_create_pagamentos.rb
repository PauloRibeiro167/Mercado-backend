class CreatePagamentos < ActiveRecord::Migration[8.0]
  def change
    create_table :pagamentos do |t|
      t.references :pedido_compras, null: false, foreign_key: true
      t.string :tipo_pagamento
      t.references :usuario, null: false, foreign_key: true
      t.date :data_pagamento
      t.text :observacao
      t.decimal :valor_pago

      # Soft Delete (Discard)
      t.datetime :discarded_at
      t.index :discarded_at
      t.timestamps
    end
  end
end
