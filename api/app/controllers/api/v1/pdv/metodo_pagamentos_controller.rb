class Api::V1::Pdv::MetodoPagamentosController < ApplicationController
before_action :set_metodo_pagamento, only: %i[ show update destroy ]

rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Método de pagamento não encontrado" } ] }, status: :not_found
end

# GET /metodo_pagamentos
def index
    ultimo_atualizado = MetodoPagamento.maximum(:updated_at)
    
    if stale?(last_modified: ultimo_atualizado)
      @metodo_pagamentos = MetodoPagamento.all
      render json: @metodo_pagamentos.map { |item| format_metodo_pagamento_json(item) }
    end
  end

  # GET /metodo_pagamentos/sync
  def sync
    data_ultima_sincronizacao = params[:desde]
    
    unless data_ultima_sincronizacao.present?
      render json: { success: false, errors: ["O parâmetro 'desde' é obrigatório"] }, status: :bad_request
      return
    end
    
    @metodo_pagamentos_alterados = MetodoPagamento.where('updated_at > ?', data_ultima_sincronizacao)
    
    render json: {
      sucesso: true,
      data_sincronizacao_atual: Time.current,
      atualizados: @metodo_pagamentos_alterados.map { |item| format_metodo_pagamento_json(item) }
    }
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
