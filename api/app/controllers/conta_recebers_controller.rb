class ContaRecebersController < ApplicationController
  before_action :set_conta_receber, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Conta a receber não encontrada" } ] }, status: :not_found
  end

  # GET /conta_recebers
  def index
    @conta_recebers = ContaReceber.all
    render json: @conta_recebers.map { |conta_receber| format_conta_receber_json(conta_receber) }
  end

  # GET /conta_recebers/1
  def show
    render json: format_conta_receber_json(@conta_receber)
  end

  # POST /conta_recebers
  def create
    @conta_receber = ContaReceber.new(conta_receber_params)

    if @conta_receber.save
      render json: format_conta_receber_json(@conta_receber), status: :created, location: @conta_receber
    else
      render_errors(@conta_receber)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # PATCH/PUT /conta_recebers/1
  def update
    if @conta_receber.update(conta_receber_params)
      render json: format_conta_receber_json(@conta_receber)
    else
      render_errors(@conta_receber)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # DELETE /conta_recebers/1
  def destroy
    @conta_receber.destroy!
    render json: { success: true, message: "Conta a receber removida com sucesso" }, status: :ok
  end

  private

    def set_conta_receber
      @conta_receber = ContaReceber.find(params.require(:id))
    end

    def conta_receber_params
      params.require(:conta_receber).permit(:venda_id, :cliente_id, :descricao, :valor, :data_vencimento, :data_recebimento, :status)
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

    def format_conta_receber_json(conta_receber)
      {
        id: conta_receber.id,
        descricao: conta_receber.descricao,
        valor: conta_receber.valor,
        data_vencimento: conta_receber.data_vencimento,
        data_recebimento: conta_receber.data_recebimento,
        status: conta_receber.status,
        created_at: conta_receber.created_at,
        updated_at: conta_receber.updated_at,
        venda: conta_receber.venda ? {
          id: conta_receber.venda.id
        } : nil,
        cliente: conta_receber.cliente ? {
          nome: conta_receber.cliente.nome
        } : nil,
        metodo_pagamento: {
          nome: conta_receber.metodo_pagamento&.nome
        },
        usuario: {
          email: conta_receber.usuario&.email,
          nome: "#{conta_receber.usuario&.primeiro_nome} #{conta_receber.usuario&.ultimo_nome}".strip
        },
        categoria: {
          nome: conta_receber.categoria&.nome
        }
      }
    end
end
