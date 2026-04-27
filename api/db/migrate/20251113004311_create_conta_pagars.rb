class CreateContaPagars < ActiveRecord::Migration[8.0]
  def change
    create_table :conta_pagars do |t|
      t.references :fornecedor, foreign_key: true
      t.references :pedido_compra, foreign_key: true
      t.references :metodo_pagamento, foreign_key: true
      t.string :numero_documento
      t.text :observacoes
      t.references :usuario, foreign_key: true
      t.decimal :valor, precision: 10, scale: 2
      t.references :categoria, foreign_key: true
      t.string :descricao
      t.date :data_vencimento
      t.string :status
      t.string :tipo_conta
      t.boolean :recorrente, default: false
      t.string :intervalo_recorrencia

      # Soft Delete (Discard)
      t.datetime :discarded_at
      t.index :discarded_at
      t.timestamps
    end

    add_index :conta_pagars, :data_vencimento
    add_index :conta_pagars, :status
    add_index :conta_pagars, :tipo_conta
    add_index :conta_pagars, :recorrente
  end
end
