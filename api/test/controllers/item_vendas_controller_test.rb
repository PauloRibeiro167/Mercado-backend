require "test_helper"

class ItemVendasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item_venda = item_vendas(:one)
  end

  test "should get index" do
    get item_vendas_url, as: :json
    assert_response :success
  end

  test "should create item_venda" do
    assert_difference("ItemVenda.count") do
      post item_vendas_url, params: { item_venda: { desconto: @item_venda.desconto, lote_id: @item_venda.lote_id, preco_unitario_vendido: @item_venda.preco_unitario_vendido, quantidade: @item_venda.quantidade, venda_id: @item_venda.venda_id } }, as: :json
    end

    assert_response :created
  end

  test "should show item_venda" do
    get item_venda_url(@item_venda), as: :json
    assert_response :success
  end

  test "should update item_venda" do
    patch item_venda_url(@item_venda), params: { item_venda: { desconto: @item_venda.desconto, lote_id: @item_venda.lote_id, preco_unitario_vendido: @item_venda.preco_unitario_vendido, quantidade: @item_venda.quantidade, venda_id: @item_venda.venda_id } }, as: :json
    assert_response :success
  end

  test "should destroy item_venda" do
    assert_difference("ItemVenda.count", -1) do
      delete item_venda_url(@item_venda), as: :json
    end

    assert_response :no_content
  end
end
