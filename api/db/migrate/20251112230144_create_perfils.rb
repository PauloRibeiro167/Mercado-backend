class CreatePerfils < ActiveRecord::Migration[8.0]
  def change
    create_table :perfils do |t|
      t.string :nome
      t.text :descricao

      t.timestamps
    end
    add_index :perfils, :nome, unique: true
  end
end
