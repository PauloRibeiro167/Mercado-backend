class Produto < ApplicationRecord
  belongs_to :categoria
  has_many :lotes, dependent: :destroy
  has_many :item_pedido_compras, dependent: :destroy
  has_many :promocaos, dependent: :destroy

  # Validações
  validates :nome, presence: true
  validates :preco, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :categoria_id, presence: true

  # Métodos para cálculo de estoque
  def estoque_total
    lotes.sum(:quantidade_atual)
  end

  def valor_estoque
    lotes.sum { |lote| lote.quantidade_atual * lote.preco_custo.to_f }
  end

  def status_estoque
    total = estoque_total
    minimo = estoque_minimo || 0

    if total == 0
      'esgotado'
    elsif total <= minimo
      'baixo'
    else
      'normal'
    end
  end
end
