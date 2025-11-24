class CreateProdutoFornecedors < ActiveRecord::Migration[8.0]
  def change
    create_table :produto_fornecedors do |t|
      t.references :produto, null: false, foreign_key: true
      t.references :fornecedor, null: false, foreign_key: true
      t.decimal :preco_custo
      t.integer :prazo_entrega_dias
      t.string :codigo_fornecedor
      t.boolean :ativo
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
