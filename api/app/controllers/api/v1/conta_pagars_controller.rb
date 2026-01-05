class Api::V1::ContaPagarsController < ApplicationController
  before_action :set_conta_pagar, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Conta a pagar não encontrada" } ] }, status: :not_found
  end

  # GET /conta_pagars
  def index
  @conta_pagars = ContaPagar.all
  render json: @conta_pagars.map { |conta_pagar| format_conta_pagar_json(conta_pagar) }
  end

  # GET /conta_pagars/1
  def show
  render json: format_conta_pagar_json(@conta_pagar)
  end

  # POST /conta_pagars
  def create
  @conta_pagar = ContaPagar.new(conta_pagar_params)

  if @conta_pagar.save
    render json: format_conta_pagar_json(@conta_pagar), status: :created, location: @conta_pagar
  else
    render_errors(@conta_pagar)
  end
  rescue ArgumentError => e
  render_invalid_enum(e)
  end

  # PATCH/PUT /conta_pagars/1
  def update
  if @conta_pagar.update(conta_pagar_params)
    render json: format_conta_pagar_json(@conta_pagar)
  else
    render_errors(@conta_pagar)
  end
  rescue ArgumentError => e
  render_invalid_enum(e)
  end

  # DELETE /conta_pagars/1
  def destroy
  @conta_pagar.destroy!
  render json: { success: true, message: "Conta a pagar removida com sucesso" }, status: :ok
  end

  private

  def set_conta_pagar
    @conta_pagar = ContaPagar.find(params.require(:id))
  end

  def conta_pagar_params
    params.require(:conta_pagar).permit(:fornecedor_id, :pedido_compra_id, :descricao, :valor, :data_vencimento, :data_pagamento, :status)
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
        { campo: "status", mensagem: "valor inválido para status" }
      ]
    }, status: :unprocessable_entity
  end

  def format_conta_pagar_json(conta_pagar)
    {
      id: conta_pagar.id,
      descricao: conta_pagar.descricao,
      valor: conta_pagar.valor,
      data_vencimento: conta_pagar.data_vencimento,
      data_pagamento: conta_pagar.data_pagamento,
      status: conta_pagar.status,
      created_at: conta_pagar.created_at,
      updated_at: conta_pagar.updated_at,
      fornecedor: conta_pagar.fornecedor ? {
        nome: conta_pagar.fornecedor.nome
      } : nil,
      pedido_compra: conta_pagar.pedido_compra ? {
        id: conta_pagar.pedido_compra.id
      } : nil,
      metodo_pagamento: {
        nome: conta_pagar.metodo_pagamento&.nome
      },
      usuario: {
        email: conta_pagar.usuario&.email,
        nome: "#{conta_pagar.usuario&.primeiro_nome} #{conta_pagar.usuario&.ultimo_nome}".strip
      },
      categoria: {
        nome: conta_pagar.categoria&.nome
      }
    }
  end
end
