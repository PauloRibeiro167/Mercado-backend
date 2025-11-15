class RemovePrecoCustoAndQuantidadeEstoqueFromProdutos < ActiveRecord::Migration[8.0]
  def change
    remove_column :produtos, :preco_custo, :decimal
    remove_column :produtos, :quantidade_estoque, :integer
  end
end
