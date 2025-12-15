require "test_helper"

class ContaPagarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @conta_pagar = conta_pagars(:one)
  end

  test "should get index" do
    get conta_pagars_url, as: :json
    assert_response :success
  end

  test "should create conta_pagar" do
    assert_difference("ContaPagar.count") do
      post conta_pagars_url, params: { conta_pagar: { data_pagamento: @conta_pagar.data_pagamento, data_vencimento: @conta_pagar.data_vencimento, descricao: @conta_pagar.descricao, fornecedor_id: @conta_pagar.fornecedor_id, pedido_compra_id: @conta_pagar.pedido_compra_id, status: @conta_pagar.status, valor: @conta_pagar.valor } }, as: :json
    end

    assert_response :created
  end

  test "should show conta_pagar" do
    get conta_pagar_url(@conta_pagar), as: :json
    assert_response :success
  end

  test "should update conta_pagar" do
    patch conta_pagar_url(@conta_pagar), params: { conta_pagar: { data_pagamento: @conta_pagar.data_pagamento, data_vencimento: @conta_pagar.data_vencimento, descricao: @conta_pagar.descricao, fornecedor_id: @conta_pagar.fornecedor_id, pedido_compra_id: @conta_pagar.pedido_compra_id, status: @conta_pagar.status, valor: @conta_pagar.valor } }, as: :json
    assert_response :success
  end

  test "should destroy conta_pagar" do
    assert_difference("ContaPagar.count", -1) do
      delete conta_pagar_url(@conta_pagar), as: :json
    end

    assert_response :no_content
  end
end
