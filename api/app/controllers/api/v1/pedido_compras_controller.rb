class Api::V1::PedidoComprasController < ApplicationController
before_action :set_pedido_compra, only: %i[ show update destroy ]

rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Pedido de compra não encontrado" } ] }, status: :not_found
end

# GET /pedido_compras
def index
  @pedido_compras = PedidoCompra.includes(:fornecedor, item_pedido_compras: :produto)
  render json: @pedido_compras.map { |pedido| format_pedido_compra_json(pedido) }
end

# GET /pedido_compras/1
def show
  render json: format_pedido_compra_json(@pedido_compra)
end

# POST /pedido_compras
def create
  @pedido_compra = PedidoCompra.new(pedido_compra_params)

  if @pedido_compra.save
    render json: format_pedido_compra_json(@pedido_compra), status: :created, location: @pedido_compra
  else
    render_errors(@pedido_compra)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# PATCH/PUT /pedido_compras/1
def update
  if @pedido_compra.update(pedido_compra_params)
    render json: format_pedido_compra_json(@pedido_compra)
  else
    render_errors(@pedido_compra)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# DELETE /pedido_compras/1
def destroy
  @pedido_compra.destroy!
  render json: { success: true, message: "Pedido de compra removido com sucesso" }, status: :ok
end

private

  def set_pedido_compra
    @pedido_compra = PedidoCompra.includes(:fornecedor, item_pedido_compras: :produto).find(params.require(:id))
  end

  def pedido_compra_params
    params.require(:pedido_compra).permit(:fornecedor_id, :data_pedido, :status, :valor_total)
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

  def format_pedido_compra_json(pedido)
    {
      id: pedido.id,
      fornecedor_id: pedido.fornecedor_id,
      data_pedido: pedido.data_pedido,
      status: pedido.status,
      valor_total: pedido.valor_total,
      created_at: pedido.created_at,
      updated_at: pedido.updated_at,
      fornecedor: {
        nome: pedido.fornecedor&.nome,
        contato_nome: pedido.fornecedor&.contato_nome
      },
      item_pedido_compras: pedido.item_pedido_compras.map { |item| format_item_pedido_compra_json(item) }
    }
  end

  def format_item_pedido_compra_json(item)
    {
      id: item.id,
      produto_id: item.produto_id,
      quantidade_pedida: item.quantidade_pedida,
      quantidade_recebida: item.quantidade_recebida,
      preco_unitario: item.preco_unitario,
      desconto: item.desconto,
      subtotal: item.subtotal,
      data_validade: item.data_validade,
      status: item.status,
      produto: {
        nome: item.produto&.nome
      }
    }
  end
end
