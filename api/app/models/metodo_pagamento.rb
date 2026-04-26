# Modelo para métodos de pagamento.
# Representa as formas de pagamento aceitas pelo sistema, com configurações específicas em JSON.
#
# @example Configuração para PIX
#   {"chave_pix": "sua-chave", "tipo_chave": "aleatoria"}
#
# @example Configuração para Cartão com Gateway
#   {"gateway": "Stone", "api_key": "abc123"}
class MetodoPagamento < ApplicationRecord
  # Enum para tipo de pagamento
  enum :tipo, %i[dineiro pix cartao debito credito transferencia]

  # @!group Validações

  # Valida que o nome esteja presente e seja único
  validates :nome,
            presence: { message: "Nome não pode ficar em branco" },
            uniqueness: { message: "Nome já está em uso" }

  # Valida que o tipo esteja presente e seja um dos permitidos
  validates :tipo,
            presence: { message: "Tipo não pode ficar em branco" },
            inclusion: { in: tipos.keys, message: "Tipo deve ser dinheiro, pix, cartao, debito, credito ou transferencia" }

  # Valida que a taxa percentual seja não-negativa
  validates :taxa_percentual,
            numericality: { greater_than_or_equal_to: 0, message: "Taxa percentual deve ser maior ou igual a zero" },
            allow_nil: true

  # Valida que a taxa fixa seja não-negativa
  validates :taxa_fixa,
            numericality: { greater_than_or_equal_to: 0, message: "Taxa fixa deve ser maior ou igual a zero" },
            allow_nil: true

  # Valida se o método está ativo ou inativo
  validates :ativo,
            inclusion: { in: [ true, false ], message: "Ativo deve ser verdadeiro ou falso" }

  # Valida presença da configuração JSON para tipos específicos
  validates :configuracao_json,
            presence: { message: "Configuração JSON não pode ficar em branco" },
            if: -> { tipo.in?(%w[pix cartao debito credito]) }

  validate :validar_configuracao_json
  # @!endgroup

  # Calcula a taxa total a ser cobrada sobre um valor.
  # A taxa é composta por uma parte percentual e uma parte fixa.
  #
  # @param valor [Decimal] O valor sobre o qual a taxa será calculada
  # @return [Decimal] O valor total da taxa calculada
  def calcular_taxa(valor)
    taxa_percentual_valor = (valor * taxa_percentual / 100) if taxa_percentual.present?
    taxa_fixa_valor = taxa_fixa || 0
    (taxa_percentual_valor || 0) + taxa_fixa_valor
  end

  # Verifica se o método de pagamento está ativo.
  #
  # @return [Boolean] true se estiver ativo, false caso contrário
  def ativo?
    ativo
  end

  private

  # Valida se o campo configuracao_json contém um JSON válido.
  # Adiciona um erro ao modelo caso o JSON seja inválido.
  #
  # @return [void]
  def validar_configuracao_json
    return if configuracao_json.blank?

    begin
      JSON.parse(configuracao_json)
    rescue JSON::ParserError
      errors.add(:configuracao_json, "deve ser um JSON válido")
    end
  end
end
