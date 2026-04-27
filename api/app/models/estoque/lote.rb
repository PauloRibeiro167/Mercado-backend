module Estoque
  class Lote < ApplicationRecord

  include Discard::Model if defined?(Discard::Model)

  after_commit :avisar_frontends, on: [:create, :update]

  private

  def avisar_frontends
    ActionCable.server.broadcast("lotes_channel", { acao: "atualizado", id: self.id })
  end

  public
  include Discard::Model

    belongs_to :produto
    has_many :item_vendas, dependent: :destroy
    has_one :estoque, dependent: :destroy
    has_many :ajuste_estoques, through: :estoque

    # Validações
    validates :quantidade_inicial,
              presence: { message: "Quantidade inicial não pode ficar em branco" },
              numericality: { only_integer: true, greater_than: 0, message: "Quantidade inicial deve ser um número inteiro maior que zero" }

    validates :preco_custo,
              presence: { message: "Preço de custo não pode ficar em branco" },
              numericality: { greater_than_or_equal_to: 0, message: "Preço de custo deve ser maior ou igual a zero" }

    validates :codigo,
              presence: { message: "Código não pode ficar em branco" },
              uniqueness: { message: "Código já está em uso" }

    validates :data_validade,
              presence: { message: "Data de validade não pode ficar em branco" },
              if: -> { controle_de_validade }

    after_create :criar_estoque

    def dias_para_vencer
      return nil unless data_validade.present?
      (data_validade - Date.current).to_i
    end

    def vencido?
      dias_para_vencer&.negative?
    end

    def proximo_vencimento?
      dias_para_vencer && dias_para_vencer <= 30
    end  private

    def criar_estoque
      Estoque.create(produto: produto, lote: self, quantidade_atual: quantidade_inicial)
    end
  end
end
