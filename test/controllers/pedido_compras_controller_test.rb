require "test_helper"

class PedidoComprasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pedido_compra = pedido_compras(:one)
  end

  test "should get index" do
    get pedido_compras_url, as: :json
    assert_response :success
  end

  test "should create pedido_compra" do
    assert_difference("PedidoCompra.count") do
      post pedido_compras_url, params: { pedido_compra: { data_pedido: @pedido_compra.data_pedido, fornecedor_id: @pedido_compra.fornecedor_id, status: @pedido_compra.status, valor_total: @pedido_compra.valor_total } }, as: :json
    end

    assert_response :created
  end

  test "should show pedido_compra" do
    get pedido_compra_url(@pedido_compra), as: :json
    assert_response :success
  end

  test "should update pedido_compra" do
    patch pedido_compra_url(@pedido_compra), params: { pedido_compra: { data_pedido: @pedido_compra.data_pedido, fornecedor_id: @pedido_compra.fornecedor_id, status: @pedido_compra.status, valor_total: @pedido_compra.valor_total } }, as: :json
    assert_response :success
  end

  test "should destroy pedido_compra" do
    assert_difference("PedidoCompra.count", -1) do
      delete pedido_compra_url(@pedido_compra), as: :json
    end

    assert_response :no_content
  end
end
