class CreateSessaoCaixas < ActiveRecord::Migration[8.0]
  def change
    create_table :sessao_caixas do |t|
      t.references :usuario, null: true, foreign_key: false
      t.datetime :abertura
      t.datetime :fechamento
      t.decimal :valor_inicial
      t.decimal :valor_final
      t.string :status

      t.timestamps
    end
  end
end
