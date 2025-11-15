class CreateContaRecebers < ActiveRecord::Migration[8.0]
  def change
    create_table :conta_recebers do |t|
      t.references :venda, foreign_key: false
      t.references :cliente, foreign_key: false
      t.string :descricao
      t.decimal :valor, precision: 10, scale: 2
      t.date :data_vencimento
      t.date :data_recebimento
      t.string :status

      t.timestamps
    end
  end
end
