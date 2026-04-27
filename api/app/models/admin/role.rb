class Admin::Role < ApplicationRecord
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
