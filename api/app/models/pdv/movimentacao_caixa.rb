module Pdv
  class MovimentacaoCaixa < ApplicationRecord
    # Enum para tipo
    enum :tipo, %i[entrada saida]

    # Associações
    belongs_to :usuario, class_name: 'Admin::Usuario'
    belongs_to :caixa
    belongs_to :origem, polymorphic: true, optional: true
    belongs_to :sessao_caixa

    # Validações
    validates :data,
              presence: { message: "Data não pode ficar em branco" }

    validates :descricao,
              presence: { message: "Descrição não pode ficar em branco" }

    validates :valor,
              presence: { message: "Valor não pode ficar em branco" },
              numericality: { greater_than: 0, message: "Valor deve ser maior que zero" }

    validates :tipo,
              presence: { message: "Tipo não pode ficar em branco" },
              inclusion: { in: tipos.keys, message: "Tipo deve ser entrada ou saida" }

    def entrada?
      tipo == "entrada"
    end

    def saida?
      tipo == "saida"
    end
  end
end
