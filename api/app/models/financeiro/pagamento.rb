module Financeiro
  class Pagamento < ApplicationRecord
    belongs_to :pedido_compra, class_name: 'Estoque::PedidoCompra', foreign_key: :pedido_compras_id
    belongs_to :usuario, class_name: 'Admin::Usuario'

    validates :pedido_compra,
              presence: { message: "Pedido de compra não pode ficar em branco" }

    validates :usuario,
              presence: { message: "Usuário não pode ficar em branco" }

    validates :valor_pago,
              presence: { message: "Valor pago não pode ficar em branco" },
              numericality: { greater_than_or_equal_to: 0, message: "Valor pago deve ser maior ou igual a zero" }

    validates :tipo_pagamento,
              presence: { message: "Tipo de pagamento não pode ficar em branco" }

    validates :data_pagamento,
              presence: { message: "Data de pagamento não pode ficar em branco" }

    validates :observacao,
              length: { maximum: 500, message: "Observação deve ter no máximo 500 caracteres" },
              allow_blank: true

    validate :valor_nao_excede_total_pedido

    # Método para verificar se o pagamento está completo
    def completo?
      valor_pago >= pedido_compra.valor_total
    end

    # Método para calcular valor restante
    def valor_restante
      [ pedido_compra.valor_total - valor_pago, 0 ].max
    end

    private

    def valor_nao_excede_total_pedido
      if valor_pago.present? && pedido_compra.present? && valor_pago > pedido_compra.valor_total
        errors.add(:valor_pago, "não pode exceder o valor total do pedido")
      end
    end
  end
end
