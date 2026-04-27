module Estoque
  # frozen_string_literal: true

  # model de pedido de compra
  class PedidoCompra < ApplicationRecord

  include Discard::Model if defined?(Discard::Model)

  after_commit :avisar_frontends, on: [:create, :update]

  private

  def avisar_frontends
    ActionCable.server.broadcast("pedido_compras_channel", { acao: "atualizado", id: self.id })
  end

  public
  include Discard::Model

    belongs_to :fornecedor
    belongs_to :usuario, class_name: 'Admin::Usuario'
    has_many :pagamentos, foreign_key: :pedido_compras_id
    has_many :item_pedido_compras, dependent: :destroy

    enum :status, {
      pendente_de_aprovacao: 0,
      aprovado: 1,
      enviado_solicitacao_orcamento: 2,
      recebido_retorno: 3,
      pedido_aprovado_fornecedor: 4,
      em_processo_envio: 5,
      checagem_produtos: 6,
      produtos_aprovado: 7,
      recebido: 8
    }

    enum :tipo_pagamento, {
      boleto: 0,
      dinheiro: 1,
      pix: 2,
      cartao: 3,
      dinheiro_e_cartao: 4
    }

    # Validações
    validates :fornecedor,
              presence: { message: "Fornecedor não pode ficar em branco" }

    validates :usuario,
              presence: { message: "Usuário não pode ficar em branco" }

    validates :data_pedido,
              presence: { message: "Data do pedido não pode ficar em branco" }

    validates :status,
              presence: { message: "Status não pode ficar em branco" }

    validates :valor_total,
              numericality: { greater_than_or_equal_to: 0, message: "Valor total deve ser maior ou igual a zero" },
              allow_nil: true

    validates :observacao,
              length: { maximum: 1000, message: "Observação deve ter no máximo 1000 caracteres" },
              allow_blank: true

    after_save :calcular_total

    # Método para calcular total
    def calcular_total
      update(valor_total: item_pedido_compras.sum(:subtotal))
    end

    # Método para verificar se pedido está completo
    def completo?
      status == "recebido"
    end

    # Método para aprovar pedido
    def aprovar
      update(status: :aprovado)
    end

    # Método para rejeitar pedido
    def rejeitar
      update(status: :pendente_de_aprovacao)
    end
  endend
