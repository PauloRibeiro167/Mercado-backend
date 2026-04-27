module Pdv
  class Promocao < ApplicationRecord
    belongs_to :produto, class_name: 'Estoque::Produto'
    belongs_to :usuario, class_name: 'Admin::Usuario'

    # Enum para tipo de promoção
    enum :tipo_promocao, {
      preco_fixo: "preco_fixo",
      desconto_percentual: "desconto_percentual",
      compre_leve: "compre_leve"
    }

    # Validações
    validates :tipo_promocao,
              presence: { message: "Tipo de promoção não pode ficar em branco" }

    validates :preco_promocional,
              numericality: { greater_than: 0, message: "Preço promocional deve ser maior que zero" },
              if: -> { tipo_promocao == "preco_fixo" }

    validates :desconto_percentual,
              numericality: { greater_than: 0, less_than_or_equal_to: 100, message: "Desconto percentual deve ser maior que zero e menor ou igual a 100" },
              if: -> { tipo_promocao == "desconto_percentual" }

    validates :quantidade_minima,
              numericality: { greater_than: 0, message: "Quantidade mínima deve ser maior que zero" },
              if: -> { tipo_promocao == "compre_leve" }

    validates :quantidade_gratis,
              numericality: { greater_than: 0, message: "Quantidade grátis deve ser maior que zero" },
              if: -> { tipo_promocao == "compre_leve" }

    validates :data_inicio,
              presence: { message: "Data de início não pode ficar em branco" }

    validates :data_fim,
              presence: { message: "Data de fim não pode ficar em branco" }

    validate :data_fim_depois_data_inicio

    # Scopes
    scope :ativas, -> { where(ativo: true).where("data_inicio <= ? AND data_fim >= ?", Time.current, Time.current) }
    scope :por_produto, ->(produto_id) { where(produto_id: produto_id) }
    scope :por_prioridade, -> { order(prioridade: :desc) }

    # Métodos
    def ativa?
      ativo && data_inicio <= Time.current && data_fim >= Time.current
    end

    def preco_final(preco_original)
      case tipo_promocao
      when "preco_fixo"
        preco_promocional
      when "desconto_percentual"
        preco_original * (1 - desconto_percentual / 100.0)
      else
        preco_original
      end
    end

    private

    def data_fim_depois_data_inicio
      if data_inicio.present? && data_fim.present? && data_fim <= data_inicio
        errors.add(:data_fim, "deve ser depois da data de início")
      end
    end
  end
end
