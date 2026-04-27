class Admin::PerfilPermissao < ApplicationRecord
  include Discard::Model if defined?(Discard::Model)

  self.table_name = "perfil_permissaos"

  after_commit :avisar_frontends, on: [ :create, :update ]

  belongs_to :perfil
  belongs_to :permissao

  validates :perfil,
            presence: { message: "Perfil não pode ficar em branco" }

  validates :permissao,
            presence: { message: "Permissão não pode ficar em branco" }

  validates_uniqueness_of :permissao_id,
                          scope: :perfil_id,
                          message: "Permissão já está associada a este perfil"
private
  def avisar_frontends
    ActionCable.server.broadcast("perfil_permissaos_channel", { acao: "atualizado", id: self.id })
  end
end
