class Cliente < ApplicationRecord
  # Validações básicas
  validates :nome, presence: true, length: { minimum: 2, maximum: 100 }
  validates :cpf, presence: true, uniqueness: true
  validates :telefone, presence: true, format: { with: /\A\(\d{2}\)\s\d{4,5}-\d{4}\z/, message: "deve estar no formato (XX) XXXXX-XXXX" }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }

  # Validador customizado para CPF
  # validate do
  #   validator = CpfValidator.new
  #   validator.validate(self)
  # end
end
