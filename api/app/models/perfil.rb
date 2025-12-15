class Perfil < ApplicationRecord
  has_many :usuario_perfis, class_name: "UsuarioPerfil", dependent: :destroy
  has_many :usuarios, through: :usuario_perfis, class_name: "Usuario"

  has_many :perfil_permissoes, class_name: "PerfilPermissao", dependent: :destroy
  has_many :permissoes, through: :perfil_permissoes

  validates :nome,
            presence: { message: "Nome não pode ficar em branco" },
            uniqueness: { message: "Nome já está em uso" }

  validates :descricao,
            presence: { message: "Descrição não pode ficar em branco" }
end
