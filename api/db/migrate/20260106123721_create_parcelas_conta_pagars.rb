class CreateParcelasContaPagars < ActiveRecord::Migration[8.0]
  def change
    create_table :parcela_conta_pagars do |t|
      t.references :conta_pagar, foreign_key: true
      t.integer :numero_parcela
      t.decimal :valor, precision: 10, scale: 2
      t.date :data_vencimento
      t.boolean :paga, default: false
      t.date :data_pagamento
      t.timestamps
    end
  end
end
