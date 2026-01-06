# Model de criação de cargos dentro do sistema.
#
# Este model gerencia os cargos disponíveis, incluindo nome, descrição e atribuições.
# Cada cargo é associado ao usuário que o criou.
#
# @attr nome [String] o nome único do cargo
# @attr descricao [String] a descrição detalhada do cargo
# @attr atribuicoes [String] as atribuições e responsabilidades do cargo
# @attr criado_por [Usuario] o usuário que criou o cargo
class Cargo < ApplicationRecord
  # Associação com o usuário que criou o cargo.
  # Obrigatoria, não pode ser nula.
  belongs_to :criado_por, class_name: "Usuario", optional: false

  # Validação do nome: presença obrigatória e unicidade.
  validates :nome,
            presence: { message: "Nome não pode ficar em branco" },
            uniqueness: { message: "Nome já está em uso" }

  # Validação da descrição: presença obrigatória.
  validates :descricao,
            presence: { message: "Descrição não pode ficar em branco" }
end
