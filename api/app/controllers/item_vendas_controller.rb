class ItemVendasController < ApplicationController
  before_action :set_item_venda, only: %i[ show update destroy ]

  # GET /item_vendas
  def index
    @item_vendas = ItemVenda.all

    render json: @item_vendas
  end

  # GET /item_vendas/1
  def show
    render json: @item_venda
  end

  # POST /item_vendas
  def create
    @item_venda = ItemVenda.new(item_venda_params)

    if @item_venda.save
      render json: @item_venda, status: :created, location: @item_venda
    else
      render json: @item_venda.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /item_vendas/1
  def update
    if @item_venda.update(item_venda_params)
      render json: @item_venda
    else
      render json: @item_venda.errors, status: :unprocessable_content
    end
  end

  # DELETE /item_vendas/1
  def destroy
    @item_venda.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_venda
      @item_venda = ItemVenda.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def item_venda_params
      params.expect(item_venda: [ :venda_id, :lote_id, :desconto, :quantidade, :preco_unitario_vendido ])
    end
end
