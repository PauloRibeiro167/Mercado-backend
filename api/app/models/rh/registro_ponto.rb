module Rh
  class RegistroPonto < ApplicationRecord
    belongs_to :funcionario

    validates :funcionario,
              presence: { message: "Funcionário não pode ficar em branco" }

    validates :data,
              presence: { message: "Data não pode ficar em branco" },
              uniqueness: { scope: :funcionario_id, message: "Já existe um registro para esta data e funcionário" }

    validates :hora_entrada,
              presence: { message: "Hora de entrada não pode ficar em branco" }

    validates :hora_saida,
              presence: { message: "Hora de saída não pode ficar em branco" }

    validates :horas_trabalhadas,
              numericality: { greater_than_or_equal_to: 0, message: "Horas trabalhadas deve ser maior ou igual a zero" }

    validates :aprovado,
              inclusion: { in: [ true, false ], message: "Aprovado deve ser verdadeiro ou falso" },
              allow_nil: true

    before_save :calcular_horas_trabalhadas

    private

    def calcular_horas_trabalhadas
      if hora_entrada.present? && hora_saida.present?
        diferenca_segundos = (hora_saida - hora_entrada).to_f
        self.horas_trabalhadas = (diferenca_segundos / 3600).round(2)
      else
        self.horas_trabalhadas = 0
      end
    end
  end
end
