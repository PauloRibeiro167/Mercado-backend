module Estoque
  class ProdutoFornecedor < ApplicationRecord
    belongs_to :produto
    belongs_to :fornecedor
    belongs_to :usuario

    # Validações
    validates :produto,
              presence: { message: "Produto não pode ficar em branco" }

    validates :fornecedor,
              presence: { message: "Fornecedor não pode ficar em branco" }

    validates :usuario,
              presence: { message: "Usuário não pode ficar em branco" }

    validates :preco_custo,
              numericality: { greater_than: 0, message: "Preço de custo deve ser maior que zero" },
              allow_nil: true

    validates :prazo_entrega_dias,
              numericality: { only_integer: true, greater_than: 0, message: "Prazo de entrega deve ser um número inteiro maior que zero" },
              allow_nil: true

    validates :codigo_fornecedor,
              uniqueness: { scope: [ :produto_id, :fornecedor_id ], message: "Código do fornecedor já está em uso para este produto e fornecedor" },
              allow_nil: true
  end
end
