module Admin
  class UsuarioPerfil < ApplicationRecord
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
end
