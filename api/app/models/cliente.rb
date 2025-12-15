class Cliente < ApplicationRecord
  # Validações básicas
  validates :nome,
            presence: { message: "Nome não pode ficar em branco" },
            length: { minimum: 2, maximum: 100, message: "Nome deve ter entre 2 e 100 caracteres" }

  validates :cpf,
            presence: { message: "CPF não pode ficar em branco" },
            uniqueness: { message: "CPF já está em uso" }

  validates :telefone,
            format: { with: /\A\(\d{2}\)\s\d{4,5}-\d{4}\z/, message: "Telefone deve estar no formato (XX) XXXXX-XXXX" },
            allow_blank: true

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email deve ter um formato válido" },
            uniqueness: { case_sensitive: false, message: "Email já está em uso" },
            allow_blank: true

  # Validador customizado para CPF
  validate do
    validator = CpfValidator.new
    validator.validate(self)
  end
end
