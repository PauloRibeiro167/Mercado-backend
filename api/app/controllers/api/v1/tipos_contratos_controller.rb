class Api::V1::TiposContratosController < ApplicationController
  before_action :set_tipos_contrato, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Tipo de contrato não encontrado" } ] }, status: :not_found
  end

  # GET /tipos_contratos
  def index
    @tipos_contratos = TiposContrato.all
    render json: @tipos_contratos.map { |tipo| format_tipos_contrato_json(tipo) }
  end

  # GET /tipos_contratos/1
  def show
    render json: format_tipos_contrato_json(@tipos_contrato)
  end

  # POST /tipos_contratos
  def create
    @tipos_contrato = TiposContrato.new(tipos_contrato_params)

    if @tipos_contrato.save
      render json: format_tipos_contrato_json(@tipos_contrato), status: :created, location: @tipos_contrato
    else
      render_errors(@tipos_contrato)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # PATCH/PUT /tipos_contratos/1
  def update
    if @tipos_contrato.update(tipos_contrato_params)
      render json: format_tipos_contrato_json(@tipos_contrato)
    else
      render_errors(@tipos_contrato)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # DELETE /tipos_contratos/1
  def destroy
    @tipos_contrato.destroy!
    render json: { success: true, message: "Tipo de contrato removido com sucesso" }, status: :ok
  end

private

  def set_tipos_contrato
    @tipos_contrato = TiposContrato.find(params.require(:id))
  end

  def tipos_contrato_params
    params.require(:tipos_contrato).permit(:nome, :descricao, :ativo)
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

  def format_tipos_contrato_json(tipo)
    {
      id: tipo.id,
      nome: tipo.nome,
      descricao: tipo.descricao,
      ativo: tipo.ativo,
      created_at: tipo.created_at,
      updated_at: tipo.updated_at
    }
  end
end
