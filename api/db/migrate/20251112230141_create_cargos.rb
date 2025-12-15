class CreateCargos < ActiveRecord::Migration[8.0]
  def change
    create_table :cargos do |t|
      t.string :nome
      t.text :descricao
      t.text :atribuicoes
      t.references :criado_por, foreign_key: { to_table: :usuarios }

      t.timestamps
    end
    add_index :cargos, :nome, unique: true
  end
end
