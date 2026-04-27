class Api::V1::Pdv::MovimentacaoCaixasController < ApplicationController
before_action :set_movimentacao_caixa, only: %i[ show update destroy ]

# GET /movimentacao_caixas
def index
  @movimentacao_caixas = MovimentacaoCaixa.all

  render json: @movimentacao_caixas
end

# GET /movimentacao_caixas/1
def show
  render json: @movimentacao_caixa
end

# POST /movimentacao_caixas
def create
  @movimentacao_caixa = MovimentacaoCaixa.new(movimentacao_caixa_params)

  if @movimentacao_caixa.save
    render json: @movimentacao_caixa, status: :created, location: @movimentacao_caixa
  else
    render json: @movimentacao_caixa.errors, status: :unprocessable_content
  end
end

# PATCH/PUT /movimentacao_caixas/1
def update
  if @movimentacao_caixa.update(movimentacao_caixa_params)
    render json: @movimentacao_caixa
  else
    render json: @movimentacao_caixa.errors, status: :unprocessable_content
  end
end

# DELETE /movimentacao_caixas/1
def destroy
  @movimentacao_caixa.destroy!
end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_movimentacao_caixa
    @movimentacao_caixa = MovimentacaoCaixa.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def movimentacao_caixa_params
    params.expect(movimentacao_caixa: [ :data, :descricao, :valor, :tipo, :usuario_id, :caixa_id, :origem_id, :origem_type, :sessao_caixa_id ])
  end
end
