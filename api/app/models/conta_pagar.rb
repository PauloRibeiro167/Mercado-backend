class ContaPagar < ApplicationRecord
  # Associações (atualizadas para opcionais onde aplicável)
  belongs_to :fornecedor, optional: true
  belongs_to :pedido_compra, optional: true
  belongs_to :metodo_pagamento
  belongs_to :usuario
  belongs_to :categoria

  enum :status, { pendente: "pendente", pago: "pago", atrasado: "atrasado" }
  enum :tipo_conta, { fornecedor: "fornecedor", aluguel: "aluguel", energia: "energia", agua: "agua", outros: "outros" }

  # Validações (atualizadas)
  validates :valor,
            numericality: { greater_than_or_equal_to: 0, message: "Valor deve ser maior ou igual a zero" },
            allow_nil: true

  validates :data_vencimento,
            presence: { message: "Data de vencimento não pode ficar em branco" }

  validates :status,
            presence: { message: "Status não pode ficar em branco" }

  validates :numero_de_parcelas,
            numericality: { greater_than: 0, message: "Número de parcelas deve ser maior que zero" }

  validates :parcela_atual,
            numericality: { greater_than: 0, message: "Parcela atual deve ser maior que zero" }

  validates :numero_recorrencias,
            numericality: { greater_than_or_equal_to: 0, message: "Número de recorrências deve ser maior ou igual a zero" }

  # Scopes
  scope :recorrentes, -> { where(recorrente: true) }
  scope :por_status, ->(status) { where(status: status) }
  scope :vencidas, -> { where("data_vencimento < ?", Date.current) }
  scope :pagas, -> { where(paga: true) }

  # Método para calcular próxima recorrência
  def calcular_proxima_recorrencia
    return unless recorrente?

    case intervalo_recorrencia
    when "mensal"
      nova_data = data_vencimento.next_month.beginning_of_month
    when "anual"
      nova_data = data_vencimento.next_year.beginning_of_year
    else
      nova_data = data_vencimento + 1.month
    end

    update(data_proxima_recorrencia: nova_data)
  end

  # Método auxiliar
  def recorrente?
    recorrente
  end
end
