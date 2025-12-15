class Estoque < ApplicationRecord
  belongs_to :produto
  belongs_to :lote, optional: true
  has_many :ajuste_estoques

  # Validações
  validates :quantidade_atual,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "Quantidade atual deve ser um número inteiro maior ou igual a zero" }

  validates :quantidade_minima,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "Quantidade mínima deve ser um número inteiro maior ou igual a zero" },
            allow_nil: true

  validates :quantidade_ideal,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "Quantidade ideal deve ser um número inteiro maior ou igual a zero" },
            allow_nil: true

  # Scopes
  scope :baixo, -> { where("quantidade_atual <= quantidade_minima") }
  scope :abaixo_ideal, -> { where("quantidade_atual < quantidade_ideal") }

  # Método para calcular média de vendas diárias (baseado em vendas dos últimos 30 dias)
  def calcular_media_vendas_diarias
    vendas_totais = ItemVenda.joins(:venda).where(lote_id: lote_id, vendas: { created_at: 30.days.ago..Time.current }).sum(:quantidade)
    dias = 30
    update(media_vendas_diarias: vendas_totais.to_f / dias)
  end

  # Método para sugerir quantidade de reposição
  def quantidade_sugerida_reposicao
    [ quantidade_ideal - quantidade_atual, 0 ].max
  end

  # Método para ajustar quantidade e recalcular média
  def ajustar_quantidade(delta)
    update(quantidade_atual: quantidade_atual + delta, ultima_atualizacao: Time.current)
    calcular_media_vendas_diarias if delta < 0  # Recalcula após venda
  end
end
