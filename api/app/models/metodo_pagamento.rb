# Modelo para métodos de pagamento.
# O campo configuracao_json armazena configurações específicas em JSON.
# Exemplos: {"chave_pix": "sua-chave", "tipo_chave": "aleatoria"} para PIX;
# {"gateway": "Stone", "api_key": "abc123"} para cartões.
class MetodoPagamento < ApplicationRecord
  # Enum para tipo
  enum :tipo, %i[dineiro pix cartao debito credito transferencia]

  # Validações
  validates :nome,
            presence: { message: "Nome não pode ficar em branco" },
            uniqueness: { message: "Nome já está em uso" }

  validates :tipo,
            presence: { message: "Tipo não pode ficar em branco" },
            inclusion: { in: tipos.keys, message: "Tipo deve ser dinheiro, pix, cartao, debito, credito ou transferencia" }

  validates :taxa_percentual,
            numericality: { greater_than_or_equal_to: 0, message: "Taxa percentual deve ser maior ou igual a zero" },
            allow_nil: true

  validates :taxa_fixa,
            numericality: { greater_than_or_equal_to: 0, message: "Taxa fixa deve ser maior ou igual a zero" },
            allow_nil: true

  validates :ativo,
            inclusion: { in: [ true, false ], message: "Ativo deve ser verdadeiro ou falso" }

  validates :configuracao_json,
            presence: { message: "Configuração JSON não pode ficar em branco" },
            if: -> { tipo.in?(%w[pix cartao debito credito]) }

  validate :validar_configuracao_json

  # Método para calcular taxa total
  def calcular_taxa(valor)
    taxa_percentual_valor = (valor * taxa_percentual / 100) if taxa_percentual.present?
    taxa_fixa_valor = taxa_fixa || 0
    (taxa_percentual_valor || 0) + taxa_fixa_valor
  end

  # Método para verificar se método está ativo
  def ativo?
    ativo
  end

  private

  def validar_configuracao_json
    return if configuracao_json.blank?

    begin
      JSON.parse(configuracao_json)
    rescue JSON::ParserError
      errors.add(:configuracao_json, "deve ser um JSON válido")
    end
  end
end
