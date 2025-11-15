class ItemPedidoComprasController < ApplicationController
  before_action :set_item_pedido_compra, only: %i[ show update destroy ]

  # GET /item_pedido_compras
  def index
    @item_pedido_compras = ItemPedidoCompra.all

    render json: @item_pedido_compras
  end

  # GET /item_pedido_compras/1
  def show
    render json: @item_pedido_compra
  end

  # POST /item_pedido_compras
  def create
    @item_pedido_compra = ItemPedidoCompra.new(item_pedido_compra_params)

    if @item_pedido_compra.save
      render json: @item_pedido_compra, status: :created, location: @item_pedido_compra
    else
      render json: @item_pedido_compra.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /item_pedido_compras/1
  def update
    if @item_pedido_compra.update(item_pedido_compra_params)
      render json: @item_pedido_compra
    else
      render json: @item_pedido_compra.errors, status: :unprocessable_content
    end
  end

  # DELETE /item_pedido_compras/1
  def destroy
    @item_pedido_compra.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_pedido_compra
      @item_pedido_compra = ItemPedidoCompra.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def item_pedido_compra_params
      params.expect(item_pedido_compra: [ :pedido_compra_id, :produto_id, :quantidade, :preco_custo_negociado ])
    end
end
