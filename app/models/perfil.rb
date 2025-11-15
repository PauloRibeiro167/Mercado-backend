class Perfil < ApplicationRecord
  # A mágica do N:N com Usuarios
  has_many :usuario_perfis, dependent: :destroy
  has_many :users, through: :usuario_perfis

  # A mágica do N:N com Permissões
  has_many :perfil_permissoes, dependent: :destroy
  has_many :permissoes, through: :perfil_permissoes
end
