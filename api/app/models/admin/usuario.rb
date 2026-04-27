class Admin::Usuario < ApplicationRecord
  include Discard::Model if defined?(Discard::Model)

  self.table_name = "usuarios"

  after_commit :avisar_frontends, on: [ :create, :update ]

  private

  def avisar_frontends
    ActionCable.server.broadcast("usuarios_channel", { acao: "atualizado", id: self.id })
  end

  public

  self.table_name = "usuarios"

  has_secure_password :senha

  belongs_to :role, class_name: "Admin::Role", optional: true
  has_one :funcionario, class_name: "Rh::Funcionario", dependent: :destroy

  # Associações para o sistema de controle de acesso (Perfis e Permissões)
  has_many :usuario_perfis, class_name: "Admin::UsuarioPerfil", dependent: :destroy
  has_many :perfis, through: :usuario_perfis, class_name: "Admin::Perfil"
  has_many :permissoes, through: :perfis, class_name: "Admin::Permissao"

  validates :email, presence: true, uniqueness: true
  validates :primeiro_nome, presence: true
  validates :ultimo_nome, presence: true

  enum :status, { inativo: 0, ativo: 1, bloqueado: 2 }

  # Aqui você também pode adicionar lógica de tokens (JWT, redefinição de senha, etc.)

  # Verifica se o usuário tem uma permissão específica baseada na chave_acao
  def has_permissao?(chave_acao)
    permissoes.exists?(chave_acao: chave_acao.to_s)
  end

  # Verifica se o usuário possui um perfil específico de acesso
  def has_perfil?(nome_perfil)
    perfis.exists?(nome: nome_perfil.to_s)
  end

  # Verifica o cargo base (Cargo do RH / Operacional)
  def has_role?(role_name)
    role&.name&.to_s == role_name.to_s
  end

  def self.policy_class
    UsuarioPolicy
  end
end
