module Pdv
  class ItemVenda < ApplicationRecord
    belongs_to :venda
    belongs_to :lote

    # Validações
    validates :quantidade,
              presence: { message: "Quantidade não pode ficar em branco" },
              numericality: { only_integer: true, greater_than: 0, message: "Quantidade deve ser um número inteiro maior que zero" }

    validates :preco_unitario_vendido,
              presence: { message: "Preço unitário vendido não pode ficar em branco" },
              numericality: { greater_than: 0, message: "Preço unitário vendido deve ser maior que zero" }

    validates :desconto,
              numericality: { greater_than_or_equal_to: 0, message: "Desconto deve ser maior ou igual a zero" },
              allow_nil: true

    validate :estoque_suficiente, on: :create

    before_save :set_quantidade_anterior
    after_save :atualizar_estoque
    after_destroy :reverter_estoque

    private

    def set_quantidade_anterior
      @quantidade_anterior = quantidade_was || 0
    end

    def atualizar_estoque
      return unless lote.estoque

      diferenca = quantidade - @quantidade_anterior
      lote.estoque.ajustar_quantidade(-diferenca)
    end

    def reverter_estoque
      return unless lote.estoque

      lote.estoque.ajustar_quantidade(quantidade)
    end

    def estoque_suficiente
      return unless lote.estoque

      if quantidade > lote.estoque.quantidade_atual
        errors.add(:quantidade, "Quantidade insuficiente em estoque. Disponível: #{lote.estoque.quantidade_atual}")
      end
    end
  end
end
