class Api::V1::MetodoPagamentosController < ApplicationController
before_action :set_metodo_pagamento, only: %i[ show update destroy ]

rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Método de pagamento não encontrado" } ] }, status: :not_found
end

# GET /metodo_pagamentos
def index
  @metodo_pagamentos = MetodoPagamento.all
  render json: @metodo_pagamentos.map { |metodo| format_metodo_pagamento_json(metodo) }
end

# GET /metodo_pagamentos/1
def show
  render json: format_metodo_pagamento_json(@metodo_pagamento)
end

# POST /metodo_pagamentos
def create
  @metodo_pagamento = MetodoPagamento.new(metodo_pagamento_params)

  if @metodo_pagamento.save
    render json: format_metodo_pagamento_json(@metodo_pagamento), status: :created, location: @metodo_pagamento
  else
    render_errors(@metodo_pagamento)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# PATCH/PUT /metodo_pagamentos/1
def update
  if @metodo_pagamento.update(metodo_pagamento_params)
    render json: format_metodo_pagamento_json(@metodo_pagamento)
  else
    render_errors(@metodo_pagamento)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# DELETE /metodo_pagamentos/1
def destroy
  @metodo_pagamento.destroy!
  render json: { success: true, message: "Método de pagamento removido com sucesso" }, status: :ok
end

private

  def set_metodo_pagamento
    @metodo_pagamento = MetodoPagamento.find(params.require(:id))
  end

  def metodo_pagamento_params
    params.require(:metodo_pagamento).permit(:nome, :taxa_percentual, :taxa_fixa, :ativo)
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
        { campo: "tipo", mensagem: "valor inválido para tipo" }
      ]
    }, status: :unprocessable_entity
  end

  def format_metodo_pagamento_json(metodo)
    {
      id: metodo.id,
      nome: metodo.nome,
      taxa_percentual: metodo.taxa_percentual,
      taxa_fixa: metodo.taxa_fixa,
      ativo: metodo.ativo,
      created_at: metodo.created_at,
      updated_at: metodo.updated_at
    }
  end
end
