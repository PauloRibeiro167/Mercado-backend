module Admin
  class Usuario < ApplicationRecord
    # Evita que o Rails tente buscar a tabela "admin_usuarios"
    self.table_name = "usuarios"

    rolify role_cname: "Admin::Role"

    has_secure_password :senha

    belongs_to :role, class_name: "Admin::Role", optional: true
    has_one :funcionario, class_name: "Rh::Funcionario", dependent: :destroy

    validates :email, presence: true, uniqueness: true
    validates :primeiro_nome, presence: true
    validates :ultimo_nome, presence: true

    enum :status, { inativo: 0, ativo: 1, bloqueado: 2 }

    # Aqui você também pode adicionar lógica de tokens (JWT, redefinição de senha, etc.)
  end
end
