class CreateProdutos < ActiveRecord::Migration[8.0]
  def change
    create_table :produtos do |t|
      t.string :nome
      t.text :descricao
      t.decimal :preco, precision: 10, scale: 2
      t.decimal :preco_custo, precision: 10, scale: 2
      t.integer :quantidade_estoque
      t.string :codigo_barras
      t.string :unidade_medida
      t.string :marca
      t.boolean :ativo
      t.references :categoria, null: false, foreign_key: true

      t.timestamps
    end
  end
end
