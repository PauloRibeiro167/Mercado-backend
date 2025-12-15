class CreateRegistroPontos < ActiveRecord::Migration[8.0]
  def change
    create_table :registro_pontos do |t|
      t.references :funcionario, foreign_key: true
      t.date :data
      t.time :hora_entrada
      t.time :hora_saida
      t.decimal :horas_trabalhadas, precision: 5, scale: 2, default: 0
      t.boolean :aprovado, default: false

      t.timestamps
    end

    add_index :registro_pontos, [ :funcionario_id, :data ]
    add_index :registro_pontos, :aprovado
  end
end
