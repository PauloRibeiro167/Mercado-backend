class Venda < ApplicationRecord
  has_many :item_vendas, dependent: :destroy
  belongs_to :metodo_pagamento
  belongs_to :sessao_caixa, optional: true
  belongs_to :cliente, optional: true

  enum :status, %i[pendente concluida cancelada]

  # Validações
  validates :status,
            presence: { message: "Status não pode ficar em branco" }

  validates :numero_venda,
            presence: { message: "Número da venda não pode ficar em branco" },
            uniqueness: { message: "Número da venda já está em uso" }

  validates :subtotal,
            numericality: { greater_than_or_equal_to: 0, message: "Subtotal deve ser maior ou igual a zero" },
            allow_nil: true

  validates :valor_taxa,
            numericality: { greater_than_or_equal_to: 0, message: "Valor da taxa deve ser maior ou igual a zero" },
            allow_nil: true

  validates :valor_total,
            numericality: { greater_than_or_equal_to: 0, message: "Valor total deve ser maior ou igual a zero" },
            allow_nil: true

  validates :valor_pago,
            numericality: { greater_than_or_equal_to: 0, message: "Valor pago deve ser maior ou igual a zero" },
            allow_nil: true

  validates :numero_parcelas,
            numericality: { only_integer: true, greater_than: 0, message: "Número de parcelas deve ser um número inteiro maior que zero" },
            if: :pagamento_via_credito?

  validate :valor_pago_suficiente

  def pagamento_via_credito?
    metodo_pagamento&.tipo == "credito"
  end

  def calcular_totais
    subtotal = item_vendas.sum { |item| item.quantidade * item.preco_unitario_vendido }
    taxa = metodo_pagamento&.taxa_percentual&.to_f || 0
    valor_taxa = subtotal * (taxa / 100)
    update(subtotal: subtotal, valor_taxa: valor_taxa, valor_total: subtotal + valor_taxa)
  end

  def calcular_troco
    return unless valor_pago && valor_total
    update(troco: [ valor_pago - valor_total, 0 ].max)
  end

  before_validation :gerar_numero_venda, on: :create

  private

  def gerar_numero_venda
    self.numero_venda ||= (Venda.maximum(:numero_venda) || 0) + 1
  end

  def valor_pago_suficiente
    return unless valor_pago && valor_total
    errors.add(:valor_pago, "Valor pago insuficiente") if valor_pago < valor_total
  end
end
