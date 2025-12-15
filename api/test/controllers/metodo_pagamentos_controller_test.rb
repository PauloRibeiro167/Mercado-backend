require "test_helper"

class MetodoPagamentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @metodo_pagamento = metodo_pagamentos(:one)
  end

  test "should get index" do
    get metodo_pagamentos_url, as: :json
    assert_response :success
  end

  test "should create metodo_pagamento" do
    assert_difference("MetodoPagamento.count") do
      post metodo_pagamentos_url, params: { metodo_pagamento: { ativo: @metodo_pagamento.ativo, nome: @metodo_pagamento.nome, taxa_fixa: @metodo_pagamento.taxa_fixa, taxa_percentual: @metodo_pagamento.taxa_percentual } }, as: :json
    end

    assert_response :created
  end

  test "should show metodo_pagamento" do
    get metodo_pagamento_url(@metodo_pagamento), as: :json
    assert_response :success
  end

  test "should update metodo_pagamento" do
    patch metodo_pagamento_url(@metodo_pagamento), params: { metodo_pagamento: { ativo: @metodo_pagamento.ativo, nome: @metodo_pagamento.nome, taxa_fixa: @metodo_pagamento.taxa_fixa, taxa_percentual: @metodo_pagamento.taxa_percentual } }, as: :json
    assert_response :success
  end

  test "should destroy metodo_pagamento" do
    assert_difference("MetodoPagamento.count", -1) do
      delete metodo_pagamento_url(@metodo_pagamento), as: :json
    end

    assert_response :no_content
  end
end
