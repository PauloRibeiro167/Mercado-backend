class Admin::UsuarioPerfil < ApplicationRecord

  include Discard::Model if defined?(Discard::Model)

  after_commit :avisar_frontends, on: [:create, :update]

  private

  def avisar_frontends
    ActionCable.server.broadcast("usuario_perfils_channel", { acao: "atualizado", id: self.id })
  end

  public
  self.table_name = "usuario_perfis"

  belongs_to :usuario
  belongs_to :perfil

  validates :usuario,
            presence: { message: "Usuário não pode ficar em branco" }

  validates :perfil,
            presence: { message: "Perfil não pode ficar em branco" }

  validates_uniqueness_of :perfil_id,
                          scope: :usuario_id,
                          message: "Perfil já está associado a este usuário"
end
