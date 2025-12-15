class CreateCategoria < ActiveRecord::Migration[8.0]
  def change
    create_table :categoria do |t|
      t.string :nome, null: false
      t.text :descricao
      t.string :imagem
      t.integer :status_da_categoria, null: false, default: 0
      t.boolean :excluido, default: false, null: false
      t.integer :taxa_de_lucro
      t.decimal :imposto, precision: 5, scale: 2, default: 0.0, null: false
      t.integer :ordem, null: false
      t.references :categoria_pai, foreign_key: { to_table: :categoria }
      t.references :criado_por, foreign_key: { to_table: :usuarios }

      t.timestamps
    end

    # Verificar e adicionar índices apenas se não existirem
    add_index :categoria, :categoria_pai_id unless index_exists?(:categoria, :categoria_pai_id)
    add_index :categoria, :criado_por_id unless index_exists?(:categoria, :criado_por_id)
    add_index :categoria, :ordem unless index_exists?(:categoria, :ordem)
    add_index :categoria, :status_da_categoria unless index_exists?(:categoria, :status_da_categoria)
    add_index :categoria, :excluido unless index_exists?(:categoria, :excluido)
    add_index :categoria, :nome, unique: true unless index_exists?(:categoria, :nome)
  end
end
