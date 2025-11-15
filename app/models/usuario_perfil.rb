class UsuarioPerfil < ApplicationRecord
  belongs_to :user
  belongs_to :perfil
end
