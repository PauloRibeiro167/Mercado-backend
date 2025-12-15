class UsuarioPolicy < ApplicationPolicy
  def index?
    true  # Permite listar usuários (ajuste conforme necessário)
  end

  def show?
    true  # Permite ver detalhes (ajuste)
  end

  def create?
    user&.has_role?(:admin)  # Apenas admin pode criar (ajuste)
  end

  def update?
    user&.has_role?(:admin) || record == user  # Admin ou dono
  end

  def destroy?
    user&.has_role?(:admin)  # Apenas admin
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.has_role?(:admin)
        scope.all  # Admin vê todos
      elsif user
        scope.where(id: user.id)  # Usuário vê apenas si mesmo
      else
        scope.none  # Nenhum usuário se não autenticado
      end
    end
  end
end
