class CreateFolhaPagamentos < ActiveRecord::Migration[8.0]
  def change
    create_table :folha_pagamentos do |t|
      t.references :funcionario, foreign_key: true
      t.references :usuario, foreign_key: true
      t.date :data_referencia
      t.integer :dias_trabalhados
      t.decimal :horas_extras, precision: 5, scale: 2, default: 0
      t.decimal :salario_base, precision: 10, scale: 2
      t.decimal :adicional_horas_extras, precision: 10, scale: 2, default: 0
      t.decimal :inss, precision: 10, scale: 2, default: 0
      t.decimal :fgts, precision: 10, scale: 2, default: 0
      t.decimal :total_bruto, precision: 10, scale: 2, default: 0
      t.decimal :total_liquido, precision: 10, scale: 2
      t.decimal :total_descontos, precision: 10, scale: 2, default: 0
      t.boolean :processada, default: false
      t.references :conta_pagar, foreign_key: true

      t.timestamps
    end

    add_index :folha_pagamentos, :data_referencia
    add_index :folha_pagamentos, :processada
  end
end
