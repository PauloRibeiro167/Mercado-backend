module Rh
  class HorarioFuncionamento < ApplicationRecord
    self.table_name = "horarios_funcionamentos"

    enum :tipo, %i[normal reduzido feriado]

    # Validações
    validates :dia_semana,
              presence: { message: "Dia da semana não pode ficar em branco" },
              if: -> { data_especial.blank? }

    validates :hora_inicio,
              presence: { message: "Hora de início não pode ficar em branco" },
              unless: -> { tipo == "feriado" }

    validates :hora_fim,
              presence: { message: "Hora de fim não pode ficar em branco" },
              unless: -> { tipo == "feriado" }

    validates :tipo,
              presence: { message: "Tipo não pode ficar em branco" }

    validates :ativo,
              inclusion: { in: [ true, false ], message: "Ativo deve ser verdadeiro ou falso" }

    scope :ativos, -> { where(ativo: true) }
    scope :por_dia, ->(dia) { where(dia_semana: dia).or(where(data_especial: dia)) }

    def aberto_em?(data_hora)
      return false if tipo == "feriado"

      if data_especial.present?
        data_hora.to_date == data_especial
      else
        data_hora.strftime("%A").downcase == dia_semana
      end && data_hora.strftime("%H:%M") >= hora_inicio.strftime("%H:%M") && data_hora.strftime("%H:%M") <= hora_fim.strftime("%H:%M")
    end

    def self.horario_fechamento_hoje
      hoje = Date.current
      horario = ativos.por_dia(hoje).first
      return nil unless horario

      Time.zone.parse("#{hoje} #{horario.hora_fim.strftime('%H:%M')}")
    end
  end
end
