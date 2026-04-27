class Admin::TiposContrato < ApplicationRecord
  self.table_name = "tipos_contratos"

  has_many :funcionarios

  validates :nome,
            presence: { message: "Nome não pode ficar em branco" },
            uniqueness: { message: "Nome já está em uso" }

  validates :ativo,
            inclusion: { in: [ true, false ], message: "Ativo deve ser verdadeiro ou falso" },
            allow_nil: true
end
