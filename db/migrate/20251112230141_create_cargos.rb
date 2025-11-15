class CreateCargos < ActiveRecord::Migration[8.0]
  def change
    create_table :cargos do |t|
      t.string :nome

      t.timestamps
    end
    add_index :cargos, :nome, unique: true
  end
end
