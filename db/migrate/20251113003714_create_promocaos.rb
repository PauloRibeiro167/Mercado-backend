class CreatePromocaos < ActiveRecord::Migration[8.0]
  def change
    create_table :promocaos do |t|
      t.references :produto, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :tipo_promocao
      t.decimal :preco_promocional, precision: 10, scale: 2
      t.datetime :data_inicio
      t.datetime :data_fim

      t.timestamps
    end
  end
end
