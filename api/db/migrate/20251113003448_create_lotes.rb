class CreateLotes < ActiveRecord::Migration[8.0]
  def change
    create_table :lotes do |t|
      t.string :codigo, null: false
      t.references :produto, null: false, foreign_key: true
      t.integer :quantidade_atual
      t.boolean :controle_de_validade, default: false
      t.integer :quantidade_inicial
      t.decimal :preco_custo, precision: 10, scale: 2
      t.date :data_validade
      t.date :data_entrada

      # Soft Delete (Discard)
      t.datetime :discarded_at
      t.index :discarded_at
      t.timestamps
    end
    add_index :lotes, :codigo, unique: true
  end
end
