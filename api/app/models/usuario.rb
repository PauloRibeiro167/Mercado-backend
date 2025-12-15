class Usuario < ApplicationRecord
  has_secure_password :senha

  rolify

  # Enums para papel e status
  belongs_to :role, optional: false
  enum :status, [ :ativo, :aguardando_confirmacao, :desabilitado ]

  # Validações básicas
  validates :email,
            presence: { message: "Email não pode ficar em branco" },
            uniqueness: { message: "Email já está em uso" }

  validates :primeiro_nome,
            presence: { message: "Primeiro nome não pode ficar em branco" }

  # Relacionamentos (ajuste inverse_of para :usuario)
  has_one :funcionario, inverse_of: :usuario, dependent: :nullify
  has_many :usuario_perfis, class_name: "UsuarioPerfil", dependent: :destroy
  has_many :perfis, through: :usuario_perfis
end
