class CreateContaPagars < ActiveRecord::Migration[8.0]
  def change
    create_table :conta_pagars do |t|
      t.references :fornecedor, foreign_key: true
      t.references :pedido_compra, foreign_key: true
      t.references :metodo_pagamento, foreign_key: true
      t.string :numero_documento
      t.decimal :juros, precision: 10, scale: 2, default: 0
      t.decimal :desconto, precision: 10, scale: 2, default: 0
      t.text :observacoes
      t.references :usuario, foreign_key: true
      t.integer :numero_de_parcelas, default: 1
      t.integer :parcela_atual, default: 1
      t.decimal :valor_original, precision: 10, scale: 2
      t.references :categoria, foreign_key: true
      t.string :descricao
      t.decimal :valor, precision: 10, scale: 2
      t.date :data_vencimento
      t.date :data_pagamento
      t.string :status
      t.string :tipo_conta

      t.boolean :recorrente, default: false
      t.string :intervalo_recorrencia
      t.integer :numero_recorrencias, default: 0
      t.date :data_proxima_recorrencia
      t.boolean :paga, default: false

      t.timestamps
    end

    add_index :conta_pagars, :data_vencimento
    add_index :conta_pagars, :status
    add_index :conta_pagars, :tipo_conta
    add_index :conta_pagars, :recorrente
    add_index :conta_pagars, :paga
  end
end
