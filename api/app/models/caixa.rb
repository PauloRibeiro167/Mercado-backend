class Caixa < ApplicationRecord
  # Associações
  belongs_to :usuario, optional: true
  has_many :sessao_caixas
  has_many :movimentacao_caixas

  # Validações
  validates :nome,
            presence: { message: "Nome não pode ficar em branco" },
            uniqueness: { message: "Nome já está em uso" }

  validates :saldo,
            numericality: { greater_than_or_equal_to: 0, message: "Saldo deve ser maior ou igual a zero" }

  validates :ativo,
            inclusion: { in: [ true, false ], message: "Ativo deve ser verdadeiro ou falso" }

  def abrir_caixa
    update(data_abertura: Date.today, ativo: true) if data_abertura.nil?
  end

  def fechar_caixa
    update(ativo: false)
  end
end
