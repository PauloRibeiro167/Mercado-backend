class VendasController < ApplicationController
  before_action :set_venda, only: %i[ show update destroy ]

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
      render json: @venda.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /vendas/1
  def update
    if @venda.update(venda_params)
      render json: @venda
    else
      render json: @venda.errors, status: :unprocessable_content
    end
  end

  # DELETE /vendas/1
  def destroy
    @venda.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_venda
      @venda = Venda.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def venda_params
      params.expect(venda: [ :status, :subtotal, :valor_taxa, :metodo_pagamento_id, :data_venda ])
    end
end
