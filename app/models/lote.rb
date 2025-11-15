class Lote < ApplicationRecord
  belongs_to :produto
  has_many :item_vendas, dependent: :destroy
  has_many :ajuste_estoques, dependent: :destroy

  # Validações
  validates :quantidade_inicial, presence: true, numericality: { greater_than: 0 }
  validates :preco_custo, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Método para calcular dias até vencer
  def dias_para_vencer
    return nil unless data_validade.present?

    (data_validade - Date.current).to_i
  end
end
