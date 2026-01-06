# Validador customizado para CPF brasileiro.
#
# Este validador verifica se o valor do CPF é válido de acordo com as regras da Receita Federal,
# incluindo cálculo dos dígitos verificadores, comprimento e formato. Permite valores em branco
# (a obrigatoriedade deve ser validada separadamente com presence: true no model).
#
# @example Uso em um model:
#   validates :cpf, presence: true
#   validate do
#     validator = CpfValidator.new
#     validator.validate(self)
#   end
class CpfValidator < ActiveModel::Validator
  # Método de validação chamado para verificar o CPF do registro
  # @param record [ActiveRecord::Base] o registro sendo validado (deve ter atributo cpf)
  # @return [void] adiciona erro ao record se CPF inválido
  def validate(record)
    return if record.cpf.blank?

    unless valid_cpf?(record.cpf)
      record.errors.add(:cpf, "não é válido")
    end
  end

  private

  # Método auxiliar para validação completa do CPF
  # @param cpf [String] o CPF a ser validado (pode incluir formatação)
  # @return [Boolean] true se CPF válido
  def valid_cpf?(cpf)
    # Remove caracteres não numéricos
    clean_cpf = cpf.gsub(/\D/, "")

    # Deve ter exatamente 11 dígitos
    return false unless clean_cpf.length == 11

    # Não pode ser sequência de dígitos iguais (ex: 111.111.111-11)
    return false if clean_cpf.chars.uniq.length == 1

    # Calcula os dígitos verificadores
    digits = clean_cpf.chars.map(&:to_i)

    # Primeiro dígito verificador
    sum = 0
    9.times { |i| sum += digits[i] * (10 - i) }
    first_verifier = (sum * 10) % 11
    first_verifier = 0 if first_verifier == 10

    return false unless first_verifier == digits[9]

    # Segundo dígito verificador
    sum = 0
    10.times { |i| sum += digits[i] * (11 - i) }
    second_verifier = (sum * 10) % 11
    second_verifier = 0 if second_verifier == 10

    second_verifier == digits[10]
  end
end
