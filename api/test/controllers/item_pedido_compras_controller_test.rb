require "test_helper"

class ItemPedidoComprasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item_pedido_compra = item_pedido_compras(:one)
  end

  test "should get index" do
    get item_pedido_compras_url, as: :json
    assert_response :success
  end

  test "should create item_pedido_compra" do
    assert_difference("ItemPedidoCompra.count") do
      post item_pedido_compras_url, params: { item_pedido_compra: { pedido_compra_id: @item_pedido_compra.pedido_compra_id, preco_custo_negociado: @item_pedido_compra.preco_custo_negociado, produto_id: @item_pedido_compra.produto_id, quantidade: @item_pedido_compra.quantidade } }, as: :json
    end

    assert_response :created
  end

  test "should show item_pedido_compra" do
    get item_pedido_compra_url(@item_pedido_compra), as: :json
    assert_response :success
  end

  test "should update item_pedido_compra" do
    patch item_pedido_compra_url(@item_pedido_compra), params: { item_pedido_compra: { pedido_compra_id: @item_pedido_compra.pedido_compra_id, preco_custo_negociado: @item_pedido_compra.preco_custo_negociado, produto_id: @item_pedido_compra.produto_id, quantidade: @item_pedido_compra.quantidade } }, as: :json
    assert_response :success
  end

  test "should destroy item_pedido_compra" do
    assert_difference("ItemPedidoCompra.count", -1) do
      delete item_pedido_compra_url(@item_pedido_compra), as: :json
    end

    assert_response :no_content
  end
end
