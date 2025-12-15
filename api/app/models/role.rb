class Role < ApplicationRecord
  has_and_belongs_to_many :usuarios, join_table: :usuarios_roles

  belongs_to :resource,
             polymorphic: true,
             optional: true


  validates :resource_type,
            inclusion: { in: Rolify.resource_types, message: "Tipo de recurso deve ser válido" },
            allow_nil: true

  validates :name,
            presence: { message: "Nome não pode ficar em branco" }

  scopify
end
