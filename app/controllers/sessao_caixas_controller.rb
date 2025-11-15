class SessaoCaixasController < ApplicationController
  before_action :set_sessao_caixa, only: %i[ show update destroy ]

  # GET /sessao_caixas
  def index
    @sessao_caixas = SessaoCaixa.all

    render json: @sessao_caixas
  end

  # GET /sessao_caixas/1
  def show
    render json: @sessao_caixa
  end

  # POST /sessao_caixas
  def create
    @sessao_caixa = SessaoCaixa.new(sessao_caixa_params)

    if @sessao_caixa.save
      render json: @sessao_caixa, status: :created, location: @sessao_caixa
    else
      render json: @sessao_caixa.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /sessao_caixas/1
  def update
    if @sessao_caixa.update(sessao_caixa_params)
      render json: @sessao_caixa
    else
      render json: @sessao_caixa.errors, status: :unprocessable_content
    end
  end

  # DELETE /sessao_caixas/1
  def destroy
    @sessao_caixa.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sessao_caixa
      @sessao_caixa = SessaoCaixa.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def sessao_caixa_params
      params.expect(sessao_caixa: [ :usuario_id, :data_abertura, :valor_abertura, :data_fechamento, :valor_fechamento_calculado, :valor_fechamento_real ])
    end
end
