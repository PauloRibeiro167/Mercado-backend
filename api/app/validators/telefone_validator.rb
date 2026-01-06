# Validador customizado para formato de telefone brasileiro.
#
# Este validador verifica se o valor do atributo tem um formato de telefone válido
# no padrão brasileiro: (XX) XXXXX-XXXX ou (XX) XXXX-XXXX. Permite valores em branco
# se allow_blank for true.
#
# @example Uso em um model:
#   validates :telefone, telefone: true
#   validates :telefone, telefone: { allow_blank: true }
class TelefoneValidator < ActiveModel::EachValidator
  # Regex para formato brasileiro: (XX) XXXXX-XXXX ou (XX) XXXX-XXXX
  TELEFONE_REGEX = /\A\(\d{2}\)\s\d{4,5}-\d{4}\z/

  # Método de validação chamado pelo Rails
  # @param record [ActiveRecord::Base] o registro sendo validado
  # @param attribute [Symbol] o nome do atributo
  # @param value [String] o valor do atributo
  # @return [void]
  def validate_each(record, attribute, value)
    return if value.blank? && options[:allow_blank]

    unless telefone_valido?(value)
      record.errors.add(attribute, options[:message] || "deve estar no formato (XX) XXXXX-XXXX")
    end
  end

  private

  # Método auxiliar para validação de formato de telefone
  # @param telefone [String] o telefone a ser validado
  # @return [Boolean] true se o telefone tem formato válido
  def telefone_valido?(telefone)
    return false if telefone.blank?
    telefone.match?(TELEFONE_REGEX)
  end
end
