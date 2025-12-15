class CreateAjusteEstoques < ActiveRecord::Migration[8.0]
  def change
    create_table :ajuste_estoques do |t|
      t.references :lote, null: false, foreign_key: true
      t.references :usuario, null: true, foreign_key: true
      t.string :tipo, null: false
      t.integer :quantidade, null: false
      t.text :motivo

      t.timestamps
    end

    add_index :ajuste_estoques, :tipo
  end
end
