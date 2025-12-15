class Cargo < ApplicationRecord
  belongs_to :criado_por, class_name: "Usuario", optional: false

  validates :nome,
            presence: { message: "Nome não pode ficar em branco" },
            uniqueness: { message: "Nome já está em uso" }

  validates :descricao,
            presence: { message: "Descrição não pode ficar em branco" }
end
