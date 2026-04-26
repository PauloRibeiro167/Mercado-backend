# Validador customizado para formato de email.
#
# Este validador verifica se o valor do atributo tem um formato de email válido
# usando regex baseada em URI::MailTo::EMAIL_REGEXP. Permite valores em branco
# se a opção allow_blank for true.
#
# @example Uso em um model:
#   class Usuario < ApplicationRecord
#     validates :email, email: true
#     validates :email, email: { allow_blank: true, message: "formato inválido" }
#   end
class EmailValidator < ActiveModel::EachValidator
  # Método de validação chamado pelo Rails para cada atributo validado.
  #
  # @param record [ActiveRecord::Base] O registro sendo validado
  # @param attribute [Symbol] O nome do atributo sendo validado
  # @param value [String, nil] O valor do atributo
  # @return [void] Adiciona erro ao record se email inválido
  # @note Permite valor em branco se allow_blank for true
  def validate_each(record, attribute, value)
    return if value.blank? && options[:allow_blank]

    unless email_valido?(value)
      record.errors.add(attribute, options[:message] || "deve ter um formato válido")
    end
  end

  private

  # Método auxiliar para validação de formato de email.
  #
  # @param email [String, nil] O email a ser validado
  # @return [Boolean] true se o email tem formato válido, false caso contrário
  # @note Usa regex padrão do Ruby para emails; retorna false para nil ou vazio
  def email_valido?(email)
    return false if email.blank?
    email.match?(URI::MailTo::EMAIL_REGEXP)
  end
end
