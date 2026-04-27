module Estoque
  class Produto < ApplicationRecord
    belongs_to :categoria
    has_many :estoques, dependent: :destroy
    has_many :lotes, dependent: :destroy
    has_many :item_pedido_compras, dependent: :destroy
    has_many :promocaos, dependent: :destroy

    # Validações baseadas nos campos da migration
    validates :nome,
              presence: { message: "Nome não pode ficar em branco" }

    validates :preco,
              presence: { message: "Preço não pode ficar em branco" },
              numericality: { greater_than_or_equal_to: 0, message: "Preço deve ser maior ou igual a zero" }

    validates :preco_custo,
              numericality: { greater_than_or_equal_to: 0, message: "Preço de custo deve ser maior ou igual a zero" },
              allow_nil: true

    validates :categoria_id,
              presence: { message: "Categoria não pode ficar em branco" }

    validates :estoque_minimo,
              numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "Estoque mínimo deve ser um número inteiro maior ou igual a zero" },
              allow_nil: true

    validates :ativo,
              inclusion: { in: [ true, false ], message: "Ativo deve ser verdadeiro ou falso" },
              allow_nil: true

    def quantidade_total
      estoques.sum(:quantidade_atual)
    end

    def valor_estoque
      estoques.sum { |estoque| estoque.quantidade_atual * (estoque.lote&.preco_custo || preco_custo).to_f }
    end

    def status_estoque
      total = quantidade_total
      minimo = estoque_minimo || estoques.minimum(:quantidade_minima) || 0

      if total == 0
        "esgotado"
      elsif total <= minimo
        "baixo"
      else
        "normal"
      end
    end

    def estoque_total
      estoques.sum(:quantidade_atual)
    end

    def self.todos_existentes
      includes(:categoria).all
    end

    def lote_custo_referencia
      lotes.where("quantidade_disponivel > 0").order(preco_custo: :desc).first
    end

    def preco_base_custo
      lote_custo_referencia&.preco_custo
    end

    def preco_venda_sugerido
      base = preco_base_custo
      return nil unless base

      margem = (categoria&.taxa_de_lucro || 0).to_d / 100
      imposto = (categoria&.imposto || 0).to_d
      base.to_d * (1 + margem) + imposto
    end
  end
end
