class Api::V1::Financeiro::CaixaReconciliacaosController < ApplicationController
  before_action :set_api_v1_caixa_reconciliacao, only: %i[ show update destroy ]

  # GET /api/v1/caixa_reconciliacaos
  def index
    @api_v1_caixa_reconciliacaos = Api::V1::Financeiro::CaixaReconciliacao.all

    render json: @api_v1_caixa_reconciliacaos
  end

  # GET /api/v1/caixa_reconciliacaos/1
  def show
    render json: @api_v1_caixa_reconciliacao
  end

  # POST /api/v1/caixa_reconciliacaos
  def create
    @api_v1_caixa_reconciliacao = Api::V1::Financeiro::CaixaReconciliacao.new(api_v1_caixa_reconciliacao_params)

    if @api_v1_caixa_reconciliacao.save
      render json: @api_v1_caixa_reconciliacao, status: :created, location: @api_v1_caixa_reconciliacao
    else
      render json: @api_v1_caixa_reconciliacao.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /api/v1/caixa_reconciliacaos/1
  def update
    if @api_v1_caixa_reconciliacao.update(api_v1_caixa_reconciliacao_params)
      render json: @api_v1_caixa_reconciliacao
    else
      render json: @api_v1_caixa_reconciliacao.errors, status: :unprocessable_content
    end
  end

  # DELETE /api/v1/caixa_reconciliacaos/1
  def destroy
    @api_v1_caixa_reconciliacao.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_caixa_reconciliacao
      @api_v1_caixa_reconciliacao = Api::V1::Financeiro::CaixaReconciliacao.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def api_v1_caixa_reconciliacao_params
      params.expect(api_v1_caixa_reconciliacao: [ :caixa_id, :usuario_responsavel_id, :usuario_operador_id, :saldo_registrado, :saldo_fisico, :diferenca, :motivo, :observacoes, :realizada_em, :status ])
    end
end
