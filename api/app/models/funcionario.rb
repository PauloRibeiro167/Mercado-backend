class Funcionario < ApplicationRecord
  belongs_to :cargo
  belongs_to :usuario
  belongs_to :tipos_contrato, class_name: "TiposContrato"

  validates :nome,
            presence: { message: "Nome não pode ficar em branco" }

  validates :cpf,
            presence: { message: "CPF não pode ficar em branco" },
            uniqueness: { message: "CPF já está em uso" }

  validates :tipos_contrato,
            presence: { message: "Tipo de contrato não pode ficar em branco" }

  validates :data_nascimento,
            presence: { message: "Data de nascimento não pode ficar em branco" }

  validates :data_admissao,
            presence: { message: "Data de admissão não pode ficar em branco" }

  validates :salario,
            numericality: { greater_than: 0, message: "Salário deve ser maior que zero" }

  validates :jornada_diaria_horas,
            numericality: { greater_than: 0, message: "Jornada diária deve ser maior que zero" }

  validates :duracao_pausa_minutos,
            numericality: { greater_than_or_equal_to: 0, message: "Duração da pausa deve ser maior ou igual a zero" }

  validate :data_nascimento_deve_ser_no_passado

  scope :ativos, -> { where(ativo: true) }
  scope :freelancers, -> { joins(:tipos_contrato).where(tipos_contratos: { nome: "freelancer" }) }  # Correção: plural

  def jornada_total_liquida
    pausa_horas = duracao_pausa_minutos.to_f / 60
    [ jornada_diaria_horas - pausa_horas, 0 ].max
  end

  def idade
    return nil unless data_nascimento
    ((Time.zone.now - data_nascimento.to_time) / 1.year.seconds).floor
  end

  def nome_completo
    nome
  end

  private

  def data_nascimento_deve_ser_no_passado
    if data_nascimento.present? && data_nascimento > Date.today
      errors.add(:data_nascimento, "deve ser no passado")
    end
  end
end
