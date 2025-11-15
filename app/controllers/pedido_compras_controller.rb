class PedidoComprasController < ApplicationController
  before_action :set_pedido_compra, only: %i[ show update destroy ]

  # GET /pedido_compras
  def index
    @pedido_compras = PedidoCompra.all

    render json: @pedido_compras
  end

  # GET /pedido_compras/1
  def show
    render json: @pedido_compra
  end

  # POST /pedido_compras
  def create
    @pedido_compra = PedidoCompra.new(pedido_compra_params)

    if @pedido_compra.save
      render json: @pedido_compra, status: :created, location: @pedido_compra
    else
      render json: @pedido_compra.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /pedido_compras/1
  def update
    if @pedido_compra.update(pedido_compra_params)
      render json: @pedido_compra
    else
      render json: @pedido_compra.errors, status: :unprocessable_content
    end
  end

  # DELETE /pedido_compras/1
  def destroy
    @pedido_compra.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pedido_compra
      @pedido_compra = PedidoCompra.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def pedido_compra_params
      params.expect(pedido_compra: [ :fornecedor_id, :data_pedido, :status, :valor_total ])
    end
end
