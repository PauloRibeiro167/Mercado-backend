class Admin::Permissao < ApplicationRecord
  has_many :perfil_permissoes, class_name: "PerfilPermissao", dependent: :destroy
  has_many :perfis, through: :perfil_permissoes

  # Validações
  validates :nome,
            presence: { message: "Nome não pode ficar em branco" },
            uniqueness: { message: "Nome já está em uso" }

  validates :chave_acao,
            presence: { message: "Chave de ação não pode ficar em branco" },
            uniqueness: { message: "Chave de ação já está em uso" }

  after_commit :avisar_frontends, on: [:create, :update]

  private

  def avisar_frontends
    ActionCable.server.broadcast("#{ch}", { acao: "atualizado", id: self.id })
  end

  public
end
