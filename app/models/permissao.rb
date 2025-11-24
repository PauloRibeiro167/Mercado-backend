class Permissao < ApplicationRecord
  has_many :perfil_permissoes, class_name: 'PerfilPermissao', dependent: :destroy
  has_many :perfis, through: :perfil_permissoes
end
