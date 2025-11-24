class CreateCategoria < ActiveRecord::Migration[8.0]
  def change
    create_table :categoria do |t|
      t.string :nome
      t.text :descricao
      t.text :imagem
      t.boolean :status, default: true, null: false
      t.integer :ordem
      t.references :categoria_pai, foreign_key: { to_table: :categoria }
      t.references :criado_por, foreign_key: { to_table: :usuarios }

      t.timestamps
    end
  end
end
