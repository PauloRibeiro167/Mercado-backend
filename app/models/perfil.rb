class Perfil < ApplicationRecord
  # A mágica do N:N com Usuarios
  has_many :usuario_perfis, class_name: 'UsuarioPerfil', dependent: :destroy
  has_many :usuarios, through: :usuario_perfis, class_name: 'Usuario'

  # A mágica do N:N com Permissões
  has_many :perfil_permissoes, class_name: 'PerfilPermissao', dependent: :destroy
  has_many :permissoes, through: :perfil_permissoes
end
