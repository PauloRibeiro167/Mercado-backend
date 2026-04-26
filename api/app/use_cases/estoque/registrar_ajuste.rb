# frozen_string_literal: true

# Caso de uso responsável por registrar ajustes de estoque com consistência transacional.
# @example Ajuste de entrada
#   Estoque::RegistrarAjuste.call!(
#     lote_id: 1, usuario_id: 42, tipo: :entrada, quantidade: 5, motivo: "Reposição"
#   )
class Estoque::RegistrarAjuste < Micro::Case
  include ActiveModel::Validations

  # @!attribute lote_id
  #   @return [Integer]
  # @!attribute usuario_id
  #   @return [Integer, nil]
  # @!attribute tipo
  #   @return [String, Symbol]
  # @!attribute quantidade
  #   @return [Integer]
  # @!attribute motivo
  #   @return [String, nil]
  attributes :lote_id, :usuario_id, :tipo, :quantidade, :motivo

  # Tipos aceitos para ajustes.
  # @return [Array<String>]
  TIPOS = %w[entrada saida ajuste].freeze

  validates :lote_id, :tipo, :quantidade, presence: true
  validates :tipo, inclusion: { in: TIPOS }
  validates :quantidade, numericality: { only_integer: true, greater_than: 0 }

  # Executa o caso de uso, persistindo o ajuste e atualizando o saldo do estoque.
  # @return [Micro::Case::Result]
  # @raise [ActiveRecord::RecordInvalid] quando a persistência falha irreversivelmente.
  def call!
    return Failure(:invalid_attributes) { { errors: validation_errors } } if invalid?

    ActiveRecord::Base.transaction do
      lote   = Lote.lock.find(lote_id)
      ajuste = AjusteEstoque.create!(lote:, usuario_id:, tipo:, quantidade:, motivo:)

      delta = delta_por_tipo(tipo, quantidade.to_i)
      lote.estoque&.ajustar_quantidade(delta)

      Success(:ok) { { ajuste:, estoque: lote.estoque } }
    end
  rescue ActiveRecord::RecordInvalid => e
    Failure(:invalid_record) { { errors: record_errors(e.record) } }
  rescue ActiveRecord::RecordNotFound
    Failure(:lote_not_found)
  end

  private

  # Converte erros de validação em formato consumível por APIs.
  # @return [Array<Hash>]
  def validation_errors
    errors.to_hash(full_messages: true).flat_map do |attr, msgs|
      Array(msgs).map { |msg| { campo: attr, mensagem: msg } }
    end
  end

  # Converte erros do ActiveRecord em formato de payload.
  # @param record [ActiveRecord::Base]
  # @return [Array<Hash>]
  def record_errors(record)
    record.errors.to_hash(full_messages: true).flat_map do |attr, msgs|
      Array(msgs).map { |msg| { campo: attr, mensagem: msg } }
    end
  end

  # Calcula o delta a aplicar no estoque conforme o tipo de ajuste.
  # @param tipo [String, Symbol]
  # @param quantidade [Integer]
  # @return [Integer]
  def delta_por_tipo(tipo, quantidade)
    case tipo.to_s
    when "entrada" then quantidade
    when "saida"   then -quantidade
    else 0
    end
  end
end
