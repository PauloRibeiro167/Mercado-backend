module Admin
  class PerfilPermissao < ApplicationRecord
    belongs_to :perfil
    belongs_to :permissao

    validates :perfil,
              presence: { message: "Perfil não pode ficar em branco" }

    validates :permissao,
              presence: { message: "Permissão não pode ficar em branco" }

    validates_uniqueness_of :permissao_id,
                            scope: :perfil_id,
                            message: "Permissão já está associada a este perfil"
  end
end
