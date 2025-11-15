class CreateLotes < ActiveRecord::Migration[8.0]
  def change
    create_table :lotes do |t|
      t.references :produto, null: false, foreign_key: true
      t.integer :quantidade_atual
      t.integer :quantidade_inicial
      t.decimal :preco_custo, precision: 10, scale: 2
      t.date :data_validade
      t.date :data_entrada

      t.timestamps
    end
  end
end
