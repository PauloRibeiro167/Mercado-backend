class CreatePromocaos < ActiveRecord::Migration[8.0]
  def change
    create_table :promocaos do |t|
      t.references :produto, null: false, foreign_key: true
      t.references :usuario, null: false, foreign_key: { to_table: :usuarios }
      t.string :tipo_promocao
      t.decimal :preco_promocional, precision: 10, scale: 2
      t.decimal :desconto_percentual, precision: 5, scale: 2
      t.integer :quantidade_minima, default: 1
      t.integer :quantidade_gratis, default: 0
      t.integer :limite_usos, default: 0
      t.boolean :ativo, default: true
      t.integer :prioridade, default: 0
      t.text :descricao
      t.datetime :data_inicio
      t.datetime :data_fim

      t.timestamps
    end

    add_index :promocaos, :ativo
    add_index :promocaos, :data_inicio
    add_index :promocaos, :data_fim
    add_index :promocaos, :prioridade
    add_index :promocaos, [ :ativo, :data_inicio, :data_fim ], name: 'index_promocaos_on_ativo_and_dates'
  end
end
