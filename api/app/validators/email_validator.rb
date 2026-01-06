# Validador customizado para formato de email.
#
# Este validador verifica se o valor do atributo tem um formato de email válido
# usando regex. Permite valores em branco se allow_blank for true.
#
# @example Uso em um model:
#   validates :email, email: true
#   validates :email, email: { allow_blank: true }
class EmailValidator < ActiveModel::EachValidator
  # Método de validação chamado pelo Rails
  # @param record [ActiveRecord::Base] o registro sendo validado
  # @param attribute [Symbol] o nome do atributo
  # @param value [String] o valor do atributo
  # @return [void]
  def validate_each(record, attribute, value)
    return if value.blank? && options[:allow_blank]

    unless email_valido?(value)
      record.errors.add(attribute, options[:message] || "deve ter um formato válido")
    end
  end

  private

  # Método auxiliar para validação de formato de email
  # @param email [String] o email a ser validado
  # @return [Boolean] true se o email tem formato válido
  def email_valido?(email)
    return false if email.blank?
    email.match?(URI::MailTo::EMAIL_REGEXP)
  end
end
