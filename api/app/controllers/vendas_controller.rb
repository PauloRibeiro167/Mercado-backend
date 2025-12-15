class VendasController < ApplicationController
  before_action :set_venda, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Venda não encontrada" } ] }, status: :not_found
  end

  # GET /vendas
  def index
    @vendas = Venda.all
    render json: @vendas
  end

  # GET /vendas/1
  def show
    render json: @venda
  end

  # POST /vendas
  def create
    @venda = Venda.new(venda_params)

    if @venda.save
      render json: @venda, status: :created, location: @venda
    else
      render_errors(@venda)
    end
  end

  # PATCH/PUT /vendas/1
  def update
    if @venda.update(venda_params)
      render json: @venda
    else
      render_errors(@venda)
    end
  end

  # DELETE /vendas/1
  def destroy
    @venda.destroy!
    render json: { success: true, message: "Venda removida com sucesso" }, status: :ok
  end

  private

    def set_venda
      @venda = Venda.find(params.require(:id))
    end

    def venda_params
      params.require(:venda).permit(:status, :subtotal, :valor_taxa, :metodo_pagamento_id, :data_venda)
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
end
