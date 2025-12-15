class CreatePedidoCompras < ActiveRecord::Migration[8.0]
  def change
    create_table :pedido_compras do |t|
      t.string :codigo, null: false
      t.references :fornecedor, null: false, foreign_key: true
      t.datetime :data_recebimento
      t.date :data_pedido, null: false
      t.text :observacao
      t.decimal :valor_total, precision: 10, scale: 2
      t.string :status, null: false, default: "pendente_de_aprovacao"
      t.boolean :recebido, null: false, default: false
      t.references :usuario, null: false, foreign_key: true
      t.boolean :aprovado, null: false, default: false
      t.datetime :solicitacao_de_orcamento

      t.decimal :valor_retorno, precision: 10, scale: 2
      t.string :tipo_pagamento

      t.timestamps
    end
    add_index :pedido_compras, :codigo, unique: true
  end
end
