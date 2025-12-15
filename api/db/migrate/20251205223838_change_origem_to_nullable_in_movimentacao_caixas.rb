class ChangeOrigemToNullableInMovimentacaoCaixas < ActiveRecord::Migration[8.0]
  def change
    change_column_null :movimentacao_caixas, :origem_type, true
    change_column_null :movimentacao_caixas, :origem_id, true
  end
end
