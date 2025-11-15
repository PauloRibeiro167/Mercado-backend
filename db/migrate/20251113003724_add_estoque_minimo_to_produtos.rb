class AddEstoqueMinimoToProdutos < ActiveRecord::Migration[8.0]
  def change
    add_column :produtos, :estoque_minimo, :integer
    add_column :produtos, :localizacao, :string
  end
end
