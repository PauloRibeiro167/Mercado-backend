class Admin::Role < ApplicationRecord

  include Discard::Model if defined?(Discard::Model)

  after_commit :avisar_frontends, on: [:create, :update]

  private

  def avisar_frontends
    ActionCable.server.broadcast("roles_channel", { acao: "atualizado", id: self.id })
  end

  public
  self.table_name = "roles"

  has_many :usuarios, class_name: "Admin::Usuario"

  # Associações padrão da gem Rolify
  has_and_belongs_to_many :usuarios_roles, class_name: "Admin::Usuario", join_table: :usuarios_roles
  belongs_to :resource, polymorphic: true, optional: true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  scopify
end
