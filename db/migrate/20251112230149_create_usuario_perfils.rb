class CreateUsuarioPerfils < ActiveRecord::Migration[8.0]
  def change
    create_table :usuario_perfils do |t|
      t.references :user, null: false, foreign_key: true
      t.references :perfil, null: false, foreign_key: true

      t.timestamps
    end
  end
end
