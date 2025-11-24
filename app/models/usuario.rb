class Usuario < ApplicationRecord
  # Adicione bcrypt para hash de senha
  has_secure_password

  # Alias para mapear password_digest ao campo da tabela
  alias_attribute :password_digest, :senha_digest

  # Enums para papel e status
  enum papel: { usuario: 0, admin: 1, ti: 2 }
  enum status: { ativo: 0, aguardando_confirmacao: 1, desabilitado: 2 }

  # Validações básicas
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  # Relacionamentos (ajuste inverse_of para :usuario)
  has_one :funcionario, inverse_of: :usuario, dependent: :nullify
  has_many :usuario_perfis, class_name: 'UsuarioPerfil', dependent: :destroy
  has_many :perfis, through: :usuario_perfis

  # Métodos para permissões baseadas em papel
  def can_view_requests?
    admin? || ti?
  end

  def can_view_reports?
    admin? || ti?
  end

  def can_view_errors?
    admin? || ti?
  end

  # Outros métodos de permissão podem ser adicionados conforme necessário
end
