class ContaPagar < ApplicationRecord
  belongs_to :fornecedor
  belongs_to :pedido_compra

  validates :fornecedor, presence: true
  validates :pedido_compra, presence: true
  validates :valor, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :data_vencimento, presence: true
  validates :status, presence: true
end
