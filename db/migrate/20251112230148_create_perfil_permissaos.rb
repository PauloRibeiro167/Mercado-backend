class CreatePerfilPermissaos < ActiveRecord::Migration[8.0]
  def change
    create_table :perfil_permissaos do |t|
      t.references :perfil, null: false, foreign_key: true
      t.references :permissao, null: false, foreign_key: true

      t.timestamps
    end
  end
end
