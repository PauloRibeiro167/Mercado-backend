class CreateTiposContratos < ActiveRecord::Migration[8.0]
  def change
    create_table :tipos_contratos do |t|
      t.string :nome
      t.text :descricao
      t.boolean :ativo

      t.timestamps
    end

    add_index :tipos_contratos, :nome, unique: true
  end
end
