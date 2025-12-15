class CreatePermissaos < ActiveRecord::Migration[8.0]
  def change
    create_table :permissaos do |t|
      t.string :nome
      t.string :chave_acao

      t.timestamps
    end
    add_index :permissaos, :nome, unique: true
    add_index :permissaos, :chave_acao, unique: true
  end
end
