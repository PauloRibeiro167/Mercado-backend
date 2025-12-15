require "test_helper"

class AjusteEstoquesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ajuste_estoque = ajuste_estoques(:one)
  end

  test "should get index" do
    get ajuste_estoques_url, as: :json
    assert_response :success
  end

  test "should create ajuste_estoque" do
    assert_difference("AjusteEstoque.count") do
      post ajuste_estoques_url, params: { ajuste_estoque: { lote_id: @ajuste_estoque.lote_id, motivo: @ajuste_estoque.motivo, quantidade: @ajuste_estoque.quantidade, tipo: @ajuste_estoque.tipo, usuario_id: @ajuste_estoque.usuario_id } }, as: :json
    end

    assert_response :created
  end

  test "should show ajuste_estoque" do
    get ajuste_estoque_url(@ajuste_estoque), as: :json
    assert_response :success
  end

  test "should update ajuste_estoque" do
    patch ajuste_estoque_url(@ajuste_estoque), params: { ajuste_estoque: { lote_id: @ajuste_estoque.lote_id, motivo: @ajuste_estoque.motivo, quantidade: @ajuste_estoque.quantidade, tipo: @ajuste_estoque.tipo, usuario_id: @ajuste_estoque.usuario_id } }, as: :json
    assert_response :success
  end

  test "should destroy ajuste_estoque" do
    assert_difference("AjusteEstoque.count", -1) do
      delete ajuste_estoque_url(@ajuste_estoque), as: :json
    end

    assert_response :no_content
  end
end
