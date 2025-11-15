class CreateContaPagars < ActiveRecord::Migration[8.0]
  def change
    create_table :conta_pagars do |t|
      t.references :fornecedor, null: false, foreign_key: true
      t.references :pedido_compra, null: false, foreign_key: true
      t.string :descricao
      t.decimal :valor, precision: 10, scale: 2
      t.date :data_vencimento
      t.date :data_pagamento
      t.string :status

      t.timestamps
    end
  end
end
