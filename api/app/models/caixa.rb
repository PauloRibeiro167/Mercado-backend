# Modela um ponto de venda físico usado para registrar movimentações financeiras.
#
# @!attribute [rw] nome
#   @return [String] nome do caixa exibido para operadores.
# @!attribute [rw] saldo
#   @return [BigDecimal] valor total disponível no caixa.
# @!attribute [rw] saldo_inicial
#   @return [BigDecimal] valor presente no caixa no momento da abertura.
# @!attribute [rw] saldo_final
#   @return [BigDecimal] valor apurado no fechamento do caixa.
# @!attribute [rw] fundo_abertura
#   @return [BigDecimal] fundo mínimo exigido para iniciar operação (>= 100).
# @!attribute [rw] limite_alerta_minimo
#   @return [BigDecimal] piso que dispara alertas automatizados (>= 75).
# @!attribute [rw] limite_alerta_maximo
#   @return [BigDecimal] teto que dispara alertas automatizados (<= 1000).
# @!attribute [rw] ativo
#   @return [Boolean] indica se o caixa está aberto para uso.
# @!attribute [rw] status
#   @return [String] estado operacional atual do caixa.
class Caixa < ApplicationRecord
  # Associações
  belongs_to :usuario, optional: true
  has_many :sessao_caixas
  has_many :movimentacao_caixas
  has_many :caixa_reconciliacoes

  enum :status, operacional: "operacional", bloqueado: "bloqueado", encerrado: "encerrado"

  # Validações
  validates :nome,
            presence: { message: "Nome não pode ficar em branco" },
            uniqueness: { message: "Nome já está em uso" }

  validates :saldo,
            numericality: { greater_than_or_equal_to: 0, message: "Saldo deve ser maior ou igual a zero" }

  validates :saldo_inicial,
            numericality: { greater_than_or_equal_to: 0, message: "Saldo inicial deve ser maior ou igual a zero" }

  validates :saldo_final,
            numericality: { greater_than_or_equal_to: 0, message: "Saldo final deve ser maior ou igual a zero" }

  validates :fundo_abertura,
            numericality: { greater_than_or_equal_to: 100, message: "Fundo de abertura deve ser pelo menos 100" }

  validates :limite_alerta_minimo,
            numericality: { greater_than_or_equal_to: 75, message: "Limite mínimo deve ser pelo menos 75" }

  validates :limite_alerta_maximo,
            numericality: { greater_than: 0, less_than_or_equal_to: 1000, message: "Limite máximo deve ser positivo e no máximo 1000" }

  validates :ativo,
            inclusion: { in: [ true, false ], message: "Ativo deve ser verdadeiro ou falso" }

  validate :validar_limites_alerta

  after_initialize :set_default_attributes, if: :new_record?

  # Abre o caixa quando ainda não possui data de abertura.
  #
  # @return [Boolean] true quando o registro é persistido com sucesso.
  def abrir_caixa
    return true unless data_abertura.nil?

    assign_attributes(data_abertura: Date.current, ativo: true)
    self.saldo_inicial = saldo if saldo_inicial.zero?
    save
  end

  # Fecha o caixa desativando-o para novas movimentações.
  #
  # @return [Boolean] true quando o registro é persistido com sucesso.
  def fechar_caixa
    update(ativo: false, saldo_final: saldo)
  end

  private

  # Define valores padrão para novos registros, respeitando atributos já informados.
  #
  # @return [void]
  def set_default_attributes
    self.saldo = 0 if saldo.nil?
    self.saldo_inicial = saldo if saldo_inicial.nil?
    self.saldo_final = saldo if saldo_final.nil?
    self.fundo_abertura = 100 if fundo_abertura.nil?
    self.limite_alerta_minimo = 75 if limite_alerta_minimo.nil?
    self.limite_alerta_maximo = 1000 if limite_alerta_maximo.nil?
    self.ativo = true if ativo.nil?
    self.status ||= :operacional
    self.data_abertura ||= Date.current
  end

  # Garante coerência entre limites mínimo e máximo, admitindo zero como não configurado.
  #
  # @return [void]
  def validar_limites_alerta
    return if limite_alerta_maximo.blank?

    if limite_alerta_minimo.present? && limite_alerta_maximo < limite_alerta_minimo
      errors.add(:limite_alerta_maximo, "deve ser maior ou igual ao limite mínimo")
    end
  end
end
