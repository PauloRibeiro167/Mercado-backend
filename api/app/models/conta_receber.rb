# Modelo que representa uma conta a receber.
# Gerencia contas de entrada, como vendas, aluguéis e outras receitas.
#
# @!attribute [rw] venda_id
#   @return [Integer, nil] ID da venda associada (opcional)
# @!attribute [rw] cliente_id
#   @return [Integer, nil] ID do cliente associado (opcional)
# @!attribute [rw] metodo_pagamento_id
#   @return [Integer] ID do método de pagamento
# @!attribute [rw] usuario_id
#   @return [Integer] ID do usuário responsável
# @!attribute [rw] categoria_id
#   @return [Integer] ID da categoria
# @!attribute [rw] valor
#   @return [Decimal, nil] Valor da conta
# @!attribute [rw] data_vencimento
#   @return [Date] Data de vencimento da conta
# @!attribute [rw] data_pagamento
#   @return [Date, nil] Data em que o pagamento foi efetuado
# @!attribute [rw] status
#   @return [String] Status da conta ('pendente', 'pago', 'atrasado')
# @!attribute [rw] tipo_conta
#   @return [String] Tipo da conta ('venda', 'aluguel', 'energia', 'agua', 'outros')
# @!attribute [rw] numero_de_parcelas
#   @return [Integer] Número total de parcelas
# @!attribute [rw] parcela_atual
#   @return [Integer] Parcela atual sendo paga
# @!attribute [rw] numero_recorrencias
#   @return [Integer] Número de recorrências
# @!attribute [rw] recorrente
#   @return [Boolean] Indica se a conta é recorrente
# @!attribute [rw] intervalo_recorrencia
#   @return [String] Intervalo de recorrência ('mensal', 'anual')
# @!attribute [rw] data_proxima_recorrencia
#   @return [Date, nil] Data da próxima recorrência
# @!attribute [rw] paga
#   @return [Boolean] Indica se a conta foi paga
# @!attribute [rw] created_at
#   @return [DateTime] Data e hora de criação do registro
# @!attribute [rw] updated_at
#   @return [DateTime] Data e hora da última atualização do registro
class ContaReceber < ApplicationRecord
  # @!group Associações

  # Associação opcional com venda
  belongs_to :venda, optional: true

  # Associação opcional com cliente
  belongs_to :cliente, optional: true

  # Associação obrigatória com método de pagamento
  belongs_to :metodo_pagamento

  # Associação obrigatória com usuário responsável
  belongs_to :usuario

  # Associação obrigatória com categoria
  belongs_to :categoria

  # @!endgroup

  # @!group Enums

  # Enum para status da conta
  enum :status, { pendente: "pendente", pago: "pago", atrasado: "atrasado" }

  # Enum para tipo de conta
  enum :tipo_conta, { venda: "venda", aluguel: "aluguel", energia: "energia", agua: "agua", outros: "outros" }

  # @!endgroup

  # @!group Validações

  # Valida que o valor seja não-negativo
  validates :valor,
            numericality: { greater_than_or_equal_to: 0, message: "Valor deve ser maior ou igual a zero" },
            allow_nil: true

  # Valida a presença da data de vencimento
  validates :data_vencimento,
            presence: { message: "Data de vencimento não pode ficar em branco" }

  # Valida a presença do status
  validates :status,
            presence: { message: "Status não pode ficar em branco" }

  # Valida que o número de parcelas seja positivo
  validates :numero_de_parcelas,
            numericality: { greater_than: 0, message: "Número de parcelas deve ser maior que zero" }

  # Valida que a parcela atual seja positiva
  validates :parcela_atual,
            numericality: { greater_than: 0, message: "Parcela atual deve ser maior que zero" }

  # Valida que o número de recorrências seja não-negativo
  validates :numero_recorrencias,
            numericality: { greater_than_or_equal_to: 0, message: "Número de recorrências deve ser maior ou igual a zero" }

  # @!endgroup

  # @!group Scopes

  # Filtra contas recorrentes
  # @return [ActiveRecord::Relation] Contas que são recorrentes
  scope :recorrentes, -> { where(recorrente: true) }

  # Filtra contas por status específico
  # @return [ActiveRecord::Relation] Contas com o status especificado
  scope :por_status, ->(status) { where(status: status) }

  # Filtra contas vencidas (data de vencimento anterior à data atual)
  # @return [ActiveRecord::Relation] Contas vencidas
  scope :vencidas, -> { where("data_vencimento < ?", Date.current) }

  # Filtra contas pagas
  # @return [ActiveRecord::Relation] Contas que foram pagas
  scope :pagas, -> { where(paga: true) }

  # @!endgroup

  # Calcula a data da próxima recorrência baseada no intervalo definido.
  # Atualiza o atributo data_proxima_recorrencia no banco de dados.
  #
  # @note Só executa se a conta for recorrente.
  # @return [void]
  # @example
  #   conta = ContaReceber.find(1)
  #   conta.calcular_proxima_recorrencia # Atualiza data_proxima_recorrencia
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

  # Verifica se a conta é recorrente.
  #
  # @return [Boolean] true se a conta for recorrente, false caso contrário
  def recorrente?
    recorrente
  end
end
