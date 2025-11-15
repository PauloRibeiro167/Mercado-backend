class CreateVendas < ActiveRecord::Migration[8.0]
  def change
    create_table :vendas do |t|
      t.string :status
      t.decimal :subtotal, precision: 10, scale: 2
      t.decimal :valor_taxa, precision: 10, scale: 2
      t.decimal :valor_total, precision: 10, scale: 2
      t.references :metodo_pagamento, null: false, foreign_key: true
      t.datetime :data_venda

      t.timestamps
    end
  end
end
