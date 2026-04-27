class Produto < ApplicationRecord
  include Discard::Model if defined?(Discard::Model)

  self.table_name = "produtos"

  belongs_to :categoria
  has_many :estoques, dependent: :destroy
  has_many :lotes, dependent: :destroy
  has_many :item_pedido_compras, dependent: :destroy
  has_many :promocaos, dependent: :destroy

  scope :todos_existentes, -> { includes(:categoria) }

  validates :nome, presence: { message: "Nome não pode ficar em branco" }
  validates :preco, presence: { message: "Preço não pode ficar em branco" }, numericality: { greater_than_or_equal_to: 0, message: "Preço deve ser maior ou igual a zero" }
  validates :preco_custo, numericality: { greater_than_or_equal_to: 0, message: "Preço de custo deve ser maior ou igual a zero" }, allow_nil: true
  validates :categoria_id, presence: { message: "Categoria não pode ficar em branco" }
  validates :estoque_minimo, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "Estoque mínimo deve ser um número inteiro maior ou igual a zero" }, allow_nil: true
  validates :ativo, inclusion: { in: [ true, false ], message: "Ativo deve ser verdadeiro ou falso" }, allow_nil: true

  after_commit :broadcast_atualizacao, on: %i[create update]

  def quantidade_total
    estoque_calculator.quantidade_total
  end

  def estoque_total
    quantidade_total
  end

  def valor_estoque
    estoque_calculator.valor_estoque
  end

  def status_estoque
    estoque_calculator.status_estoque
  end

  def lote_custo_referencia
    estoque_calculator.lote_custo_referencia
  end

  def preco_base_custo
    estoque_calculator.preco_base_custo
  end

  def preco_venda_sugerido
    Estoque::CalculadoraDePrecoService.new(categoria, preco_base_custo).calcular
  end

  private

  def broadcast_atualizacao
    Produtos::NotificadorService.new(self).atualizado
  end

  def estoque_calculator
    @estoque_calculator ||= Estoque::ProdutoEstoqueService.new(self)
  end
end
