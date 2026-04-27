module Financeiro
  # Model para formatação de contas a pagar dentro do sistema.
  #
  # Esta classe gerencia contas a pagar, incluindo fornecedores, aluguéis, energia, água e outros tipos.
  # Suporta recorrências e diferentes status de pagamento. Associada a categorias para
  # organização financeira. Parcelas são gerenciadas em modelo separado.
  #
  # @attr categoria [Categoria] a categoria financeira associada para organização
  # @attr data_vencimento [Date] a data de vencimento da conta
  # @attr fornecedor [Fornecedor] o fornecedor associado (opcional)
  # @attr intervalo_recorrencia [String] o intervalo de recorrência ('mensal', 'anual', 'trimestral', 'bimestral', 'ocorrencia_unica')
  # @attr metodo_pagamento [MetodoPagamento] o método de pagamento usado
  # @attr pedido_compra [PedidoCompra] o pedido de compra associado (opcional, padrão nil)
  # @attr recorrente [Boolean] indica se a conta é recorrente
  # @attr status [String] o status da conta ('pendente', 'pago', 'atrasado')
  # @attr tipo_conta [String] o tipo da conta ('fornecedor', 'aluguel', 'energia', 'agua', 'outros')
  # @attr usuario [Usuario] o usuário responsável pela conta
  # @attr valor [Decimal] o valor da conta (pode ser nil)
  class ContaPagar < ApplicationRecord
    # Associações
    belongs_to :fornecedor, class_name: 'Estoque::Fornecedor', optional: true
    belongs_to :pedido_compra, class_name: 'Estoque::PedidoCompra', optional: true
    belongs_to :metodo_pagamento
    belongs_to :usuario, class_name: 'Admin::Usuario'
    belongs_to :categoria, class_name: 'Estoque::Categoria'
    has_many :parcelas, class_name: 'ParcelaContaPagar', dependent: :destroy

    # Enums
    enum :status, { pendente: "pendente", pago: "pago", atrasado: "atrasado" }
    enum :tipo_conta, { fornecedor: "fornecedor", aluguel: "aluguel", energia: "energia", agua: "agua", outros: "outros" }
    enum :intervalo_recorrencia, { mensal: "mensal", anual: "anual", trimestral: "trimestral", bimestral: "bimestral", ocorrencia_unica: "ocorrencia_unica" }, suffix: true

    # Validações
    validates :valor, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :data_vencimento, presence: true
    validates :status, presence: true

    # Scopes
    scope :recorrentes, -> { where(recorrente: true) }
    scope :por_status, ->(status) { where(status: status) }
    scope :vencidas, -> { where("data_vencimento < ?", Date.current) }
    scope :pagas, -> { where(status: :pago) }

    # Calcula a data da próxima recorrência baseada no intervalo.
    #
    # @return [Date] a data calculada
    def calcular_proxima_recorrencia
      return unless recorrente?

      case intervalo_recorrencia
      when "mensal"
        data_vencimento.next_month.beginning_of_month
      when "anual"
        data_vencimento.next_year.beginning_of_year
      else
        data_vencimento + 1.month
      end
    end

    # Verifica se a conta é recorrente.
    #
    # @return [Boolean] true se recorrente
    def recorrente?
      recorrente
    end
  end
end
