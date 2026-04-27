module Admin
  class Perfil < ApplicationRecord
    # Associação com a tabela de junção entre perfis e usuários
    has_many :usuario_perfis, class_name: "UsuarioPerfil", dependent: :destroy
    has_many :usuarios, through: :usuario_perfis, class_name: "Usuario"

    # Associação com as permissões atribuídas ao perfil
    has_many :perfil_permissoes, class_name: "PerfilPermissao", dependent: :destroy

    validates :nome,
              presence: { message: "Nome não pode ficar em branco" },
              uniqueness: { message: "Nome já está em uso" }

    validates :descricao,
              presence: { message: "Descrição não pode ficar em branco" }
  end
end
