module Api
  module V1
    class PagamentosController < ApplicationController
  before_action :set_pagamento, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Pagamento não encontrado" } ] }, status: :not_found
  end

  # GET /pagamentos
  def index
    @pagamentos = Pagamento.all
    render json: @pagamentos.map { |pagamento| format_pagamento_json(pagamento) }
  end

  # GET /pagamentos/1
  def show
    render json: format_pagamento_json(@pagamento)
  end

  # POST /pagamentos
  def create
    @pagamento = Pagamento.new(pagamento_params)

    if @pagamento.save
      render json: format_pagamento_json(@pagamento), status: :created, location: @pagamento
    else
      render_errors(@pagamento)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # PATCH/PUT /pagamentos/1
  def update
    if @pagamento.update(pagamento_params)
      render json: format_pagamento_json(@pagamento)
    else
      render_errors(@pagamento)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # DELETE /pagamentos/1
  def destroy
    @pagamento.destroy!
    render json: { success: true, message: "Pagamento removido com sucesso" }, status: :ok
  end

  private

    def set_pagamento
      @pagamento = Pagamento.find(params.require(:id))
    end

    def pagamento_params
      params.require(:pagamento).permit(:pedido_compras_id, :tipo_pagamento, :data_pagamento, :observacao, :valor_pago)
    end

    def render_errors(record)
      errors = record.errors.map do |error|
        {
          campo: error.attribute.to_s,
          mensagem: error.message
        }
      end
      render json: { success: false, errors: errors }, status: :unprocessable_entity
    end

    def render_invalid_enum(_error)
      render json: {
        success: false,
        errors: [
          { campo: "tipo_pagamento", mensagem: "valor inválido para tipo_pagamento" }
        ]
      }, status: :unprocessable_entity
    end

    def format_pagamento_json(pagamento)
      {
        id: pagamento.id,
        pedido_compras_id: pagamento.pedido_compras_id,
        tipo_pagamento: pagamento.tipo_pagamento,
        data_pagamento: pagamento.data_pagamento,
        observacao: pagamento.observacao,
        valor_pago: pagamento.valor_pago,
        usuario: {
          id: pagamento.usuario_id,
          nome: "#{pagamento.usuario&.primeiro_nome} #{pagamento.usuario&.ultimo_nome}".strip
        },
        motivo: pagamento.observacao || "Pagamento realizado",
        created_at: pagamento.created_at,
        updated_at: pagamento.updated_at
      }
    end

    def format_movimentacao_caixa_json(movimentacao)
      {
        id: movimentacao.id,
        data: movimentacao.data,
        descricao: movimentacao.descricao,
        valor: movimentacao.valor,
        tipo: movimentacao.tipo,
        usuario: {
          id: movimentacao.usuario_id,
          nome: "#{movimentacao.usuario&.primeiro_nome} #{movimentacao.usuario&.ultimo_nome}".strip
        },
        caixa_id: movimentacao.caixa_id,
        origem_type: movimentacao.origem_type,
        origem_id: movimentacao.origem_id,
        sessao_caixa_id: movimentacao.sessao_caixa_id,
        created_at: movimentacao.created_at,
        updated_at: movimentacao.updated_at
      }
    end
end

  end
end
