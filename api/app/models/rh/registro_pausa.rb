module Rh
  class RegistroPausa < ApplicationRecord
    belongs_to :funcionario

    # Em Rails 8, o nome do campo deve ser o primeiro argumento (símbolo)
    enum :status, { pendente: 0, em_andamento: 1, concluida: 2, rejeitada: 3 }

    validates :inicio, presence: true
    validates :tipo_pausa, presence: true
    validate :fim_deve_ser_apos_inicio

    private

    def fim_deve_ser_apos_inicio
      if inicio.present? && fim.present? && fim < inicio
        errors.add(:fim, "deve ser posterior ao horário de início")
      end
    end
  end
end
