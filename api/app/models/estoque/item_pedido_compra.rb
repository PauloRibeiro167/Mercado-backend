module Estoque
  class ItemPedidoCompra < ApplicationRecord

  include Discard::Model if defined?(Discard::Model)

  after_commit :avisar_frontends, on: [:create, :update]

  private

  def avisar_frontends
    ActionCable.server.broadcast("item_pedido_compras_channel", { acao: "atualizado", id: self.id })
  end

  public
    belongs_to :pedido_compra
    belongs_to :produto

    enum :status, pendente: 0, parcialmente_recebido: 1, recebido: 2

    validates :quantidade_pedida,
              presence: { message: "Quantidade pedida não pode ficar em branco" },
              numericality: { greater_than: 0, message: "Quantidade pedida deve ser maior que zero" }

    validates :quantidade_recebida,
              numericality: { greater_than_or_equal_to: 0, message: "Quantidade recebida deve ser maior ou igual a zero" },
              allow_nil: true

    validates :preco_unitario,
              presence: { message: "Preço unitário não pode ficar em branco" },
              numericality: { greater_than: 0, message: "Preço unitário deve ser maior que zero" }

    validates :desconto,
              numericality: { greater_than_or_equal_to: 0, message: "Desconto deve ser maior ou igual a zero" },
              allow_nil: true

    validates :data_validade,
              presence: { message: "Data de validade não pode ficar em branco" },
              if: -> { quantidade_recebida.to_i > 0 }

    before_save :calcular_subtotal

    scope :proximos_vencimento, ->(dias = 30) { where("data_validade <= ?", dias.days.from_now).order(:data_validade) }
    scope :recebidos, -> { where(status: :recebido) }
    scope :pendentes, -> { where(status: :pendente) }

    private

    def calcular_subtotal
      if quantidade_recebida.present? && preco_unitario.present?
        valor_bruto = quantidade_recebida * preco_unitario
        desconto_total = desconto || 0
        self.subtotal = valor_bruto - desconto_total
      end
    end
  end
end
