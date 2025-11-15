class CreateMetodoPagamentos < ActiveRecord::Migration[8.0]
  def change
    create_table :metodo_pagamentos do |t|
      t.string :nome
      t.decimal :taxa_percentual, precision: 5, scale: 2
      t.decimal :taxa_fixa, precision: 10, scale: 2
      t.boolean :ativo

      t.timestamps
    end
  end
end
