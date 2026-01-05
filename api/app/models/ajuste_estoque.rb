class AjusteEstoque < ApplicationRecord
  belongs_to :lote
  belongs_to :usuario, optional: true

  enum :tipo, %i[entrada saida ajuste]

  # Validações
  validates :tipo,
            presence: { message: "Tipo não pode ficar em branco" }

  validates :quantidade,
            presence: { message: "Quantidade não pode ficar em branco" },
            numericality: { only_integer: true, greater_than: 0, message: "Quantidade deve ser um número inteiro maior que zero" }

  after_initialize :set_tipo_default, if: -> { tipo.nil? }

  # Callbacks para atualizar estoque
  after_save :atualizar_estoque
  before_destroy :reverter_estoque

  private

  def set_tipo_default
    self.tipo ||= :entrada
  end

  def atualizar_estoque
    delta = tipo == "entrada" ? quantidade : -quantidade
    lote.estoque&.ajustar_quantidade(delta)
  end

  def reverter_estoque
    delta = tipo == "entrada" ? -quantidade : quantidade
    lote.estoque&.ajustar_quantidade(delta)
  end
end
