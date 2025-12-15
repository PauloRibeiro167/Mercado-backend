require "test_helper"

class PagamentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pagamento = pagamentos(:one)
  end

  test "should get index" do
    get pagamentos_url, as: :json
    assert_response :success
  end

  test "should create pagamento" do
    assert_difference("Pagamento.count") do
      post pagamentos_url, params: { pagamento: { pedido_compra_id: @pagamento.pedido_compra_id, tipo_pagamento: @pagamento.tipo_pagamento, valor_pago: @pagamento.valor_pago } }, as: :json
    end

    assert_response :created
  end

  test "should show pagamento" do
    get pagamento_url(@pagamento), as: :json
    assert_response :success
  end

  test "should update pagamento" do
    patch pagamento_url(@pagamento), params: { pagamento: { pedido_compra_id: @pagamento.pedido_compra_id, tipo_pagamento: @pagamento.tipo_pagamento, valor_pago: @pagamento.valor_pago } }, as: :json
    assert_response :success
  end

  test "should destroy pagamento" do
    assert_difference("Pagamento.count", -1) do
      delete pagamento_url(@pagamento), as: :json
    end

    assert_response :no_content
  end
end
