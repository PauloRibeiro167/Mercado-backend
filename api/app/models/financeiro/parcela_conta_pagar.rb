module Financeiro
  # Modelo que representa uma parcela de uma conta a pagar.
  # Armazena os detalhes de cada pagamento fracionado de uma conta.
  #
  # @!attribute [rw] conta_pagar_id
  #   @return [Integer] ID da conta a pagar à qual esta parcela pertence
  # @!attribute [rw] numero_parcela
  #   @return [Integer] O número sequencial desta parcela (ex: 1, 2, 3...)
  # @!attribute [rw] valor
  #   @return [Decimal] O valor monetário desta parcela
  # @!attribute [rw] data_vencimento
  #   @return [Date] A data limite para pagamento desta parcela
  # @!attribute [rw] paga
  #   @return [Boolean] Indica se a parcela já foi paga
  # @!attribute [rw] data_pagamento
  #   @return [Date, nil] A data em que o pagamento foi efetivado (se pago)
  class ParcelaContaPagar < ApplicationRecord
    # Associações
    belongs_to :conta_pagar

    # Validações

    # Valida a presença e o valor positivo do número da parcela
    validates :numero_parcela, presence: true, numericality: { greater_than: 0 }

    # Valida que o valor seja não-negativo
    validates :valor, numericality: { greater_than_or_equal_to: 0 }

    # Valida a presença da data de vencimento
    validates :data_vencimento, presence: true
  end
end
