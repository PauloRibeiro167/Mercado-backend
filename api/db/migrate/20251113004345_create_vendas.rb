class CreateVendas < ActiveRecord::Migration[8.0]
  def change
    create_table :vendas do |t|
      t.string :status
      t.decimal :subtotal, precision: 10, scale: 2
      t.decimal :valor_taxa, precision: 10, scale: 2
      t.decimal :valor_total, precision: 10, scale: 2
      t.references :metodo_pagamento, null: false, foreign_key: true
      t.references :sessao_caixa, null: true, foreign_key: true
      t.datetime :data_venda

      t.integer :numero_venda
      t.decimal :valor_pago, precision: 10, scale: 2
      t.decimal :troco, precision: 10, scale: 2
      t.integer :numero_parcelas, default: 1
      t.references :cliente, null: true, foreign_key: true
      t.string :motivo_cancelamento, null: true
      t.text :detalhes_cancelamento, null: true

      t.timestamps
    end

    add_index :vendas, :numero_venda, unique: true
  end
end
