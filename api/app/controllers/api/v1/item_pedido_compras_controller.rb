class Api::V1::ItemPedidoComprasController < ApplicationController
before_action :set_item_pedido_compra, only: %i[ show update destroy ]

rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Item de pedido de compra não encontrado" } ] }, status: :not_found
end

# GET /item_pedido_compras
def index
  @item_pedido_compras = ItemPedidoCompra.all
  render json: @item_pedido_compras.map { |item_pedido_compra| format_item_pedido_compra_json(item_pedido_compra) }
end

# GET /item_pedido_compras/1
def show
  render json: format_item_pedido_compra_json(@item_pedido_compra)
end

# POST /item_pedido_compras
def create
  @item_pedido_compra = ItemPedidoCompra.new(item_pedido_compra_params)

  if @item_pedido_compra.save
    render json: format_item_pedido_compra_json(@item_pedido_compra), status: :created, location: @item_pedido_compra
  else
    render_errors(@item_pedido_compra)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# PATCH/PUT /item_pedido_compras/1
def update
  if @item_pedido_compra.update(item_pedido_compra_params)
    render json: format_item_pedido_compra_json(@item_pedido_compra)
  else
    render_errors(@item_pedido_compra)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# DELETE /item_pedido_compras/1
def destroy
  @item_pedido_compra.destroy!
  render json: { success: true, message: "Item de pedido de compra removido com sucesso" }, status: :ok
end

private

  def set_item_pedido_compra
    @item_pedido_compra = ItemPedidoCompra.find(params.require(:id))
  end

  def item_pedido_compra_params
    params.require(:item_pedido_compra).permit(:pedido_compra_id, :produto_id, :quantidade, :preco_custo_negociado)
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

  def format_item_pedido_compra_json(item_pedido_compra)
    {
      id: item_pedido_compra.id,
      quantidade_pedida: item_pedido_compra.quantidade_pedida,
      quantidade_recebida: item_pedido_compra.quantidade_recebida,
      preco_unitario: item_pedido_compra.preco_unitario,
      desconto: item_pedido_compra.desconto,
      data_validade: item_pedido_compra.data_validade,
      subtotal: item_pedido_compra.subtotal,
      status: item_pedido_compra.status,
      created_at: item_pedido_compra.created_at,
      updated_at: item_pedido_compra.updated_at,
      pedido_compra: {
        id: item_pedido_compra.pedido_compra&.id
      },
      produto: {
        id: item_pedido_compra.produto&.id,
        nome: item_pedido_compra.produto&.nome,
        preco: item_pedido_compra.produto&.preco,
        unidade_medida: item_pedido_compra.produto&.unidade_medida,
        descricao: item_pedido_compra.produto&.descricao
      }
    }
  end
end
