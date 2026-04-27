module Pdv
  # Modelo que representa um cliente do mercadinho.
  #
  # Esta classe gerencia os dados dos clientes que realizam compras no estabelecimento,
  # incluindo informações pessoais como nome, CPF, telefone e email. Os clientes

  # @see EmailValidator
  # @see TelefoneValidator
  # @see CpfValidator
  #
  # @attr nome [String] o nome completo do cliente (2-100 caracteres)
  # @attr cpf [String] o CPF único do cliente (validado)
  # @attr telefone [String] o telefone do cliente no formato (XX) XXXXX-XXXX (opcional)
  # @attr email [String] o email único do cliente (opcional, validado)
  class Cliente < ApplicationRecord
    # Validações básicas

    # Validação do nome: presença obrigatória e comprimento entre 2 e 100 caracteres
    validates :nome,
              presence: { message: "Nome não pode ficar em branco" },
              length: { minimum: 2, maximum: 100, message: "Nome deve ter entre 2 e 100 caracteres" }

    # Validação do CPF: presença obrigatória e unicidade
    # @see CpfValidator
    validates :cpf,
              presence: { message: "CPF não pode ficar em branco" },
              uniqueness: { message: "CPF já está em uso" }

    # Validação do telefone: formato específico (opcional)
    # Utiliza o validador auxiliar TelefoneValidator para verificar formato brasileiro
    # @see TelefoneValidator
    validates :telefone,
              telefone: { allow_blank: true }

    # Validação do email: formato válido e unicidade (opcional)
    # Utiliza o validador auxiliar EmailValidator para verificar formato
    # @see EmailValidator
    validates :email,
              email: { allow_blank: true },
              uniqueness: { case_sensitive: false, message: "Email já está em uso" }

    # Validação para CPF
    # Utiliza CpfValidator para verificar se o CPF é brasileiro, e se é valido
    def validate_cpf
      validator = CpfValidator.new
      validator.validate(self)
    end

    validate :validate_cpf
  end
end
