class CreateAjusteEstoques < ActiveRecord::Migration[8.0]
  def change
    create_table :ajuste_estoques do |t|
      t.references :lote, null: false, foreign_key: true
      t.references :usuario, null: true, foreign_key: false
      t.string :tipo
      t.integer :quantidade
      t.text :motivo

      t.timestamps
    end
  end
end
