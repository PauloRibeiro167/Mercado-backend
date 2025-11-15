class PerfilPermissao < ApplicationRecord
  belongs_to :perfil
  belongs_to :permissao
end
