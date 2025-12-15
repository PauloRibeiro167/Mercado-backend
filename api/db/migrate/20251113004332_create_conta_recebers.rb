class CreateContaRecebers < ActiveRecord::Migration[8.0]
  def change
    create_table   :conta_recebers do |t|
      t.references :venda, foreign_key: false
      t.references :cliente, foreign_key: false
      t.references :metodo_pagamento, foreign_key: true
      t.string     :numero_documento
      t.decimal    :juros, precision: 10, scale: 2, default: 0
      t.decimal    :desconto, precision: 10, scale: 2, default: 0
      t.text       :observacoes
      t.references :usuario, foreign_key: true
      t.integer    :numero_de_parcelas, default: 1
      t.integer    :parcela_atual, default: 1
      t.decimal    :valor_original, precision: 10, scale: 2
      t.references :categoria, foreign_key: true
      t.string     :descricao
      t.decimal    :valor, precision: 10, scale: 2
      t.date       :data_vencimento
      t.date       :data_recebimento
      t.string     :status
      t.string     :tipo_conta

      t.boolean    :recorrente, default: false
      t.string     :intervalo_recorrencia
      t.integer    :numero_recorrencias, default: 0
      t.date       :data_proxima_recorrencia
      t.boolean    :paga, default: false

      t.timestamps
    end

    add_index :conta_recebers, :data_vencimento
    add_index :conta_recebers, :status
    add_index :conta_recebers, :tipo_conta
    add_index :conta_recebers, :recorrente
    add_index :conta_recebers, :paga
  end
end
