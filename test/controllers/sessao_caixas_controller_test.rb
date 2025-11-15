require "test_helper"

class SessaoCaixasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sessao_caixa = sessao_caixas(:one)
  end

  test "should get index" do
    get sessao_caixas_url, as: :json
    assert_response :success
  end

  test "should create sessao_caixa" do
    assert_difference("SessaoCaixa.count") do
      post sessao_caixas_url, params: { sessao_caixa: { data_abertura: @sessao_caixa.data_abertura, data_fechamento: @sessao_caixa.data_fechamento, usuario_id: @sessao_caixa.usuario_id, valor_abertura: @sessao_caixa.valor_abertura, valor_fechamento_calculado: @sessao_caixa.valor_fechamento_calculado, valor_fechamento_real: @sessao_caixa.valor_fechamento_real } }, as: :json
    end

    assert_response :created
  end

  test "should show sessao_caixa" do
    get sessao_caixa_url(@sessao_caixa), as: :json
    assert_response :success
  end

  test "should update sessao_caixa" do
    patch sessao_caixa_url(@sessao_caixa), params: { sessao_caixa: { data_abertura: @sessao_caixa.data_abertura, data_fechamento: @sessao_caixa.data_fechamento, usuario_id: @sessao_caixa.usuario_id, valor_abertura: @sessao_caixa.valor_abertura, valor_fechamento_calculado: @sessao_caixa.valor_fechamento_calculado, valor_fechamento_real: @sessao_caixa.valor_fechamento_real } }, as: :json
    assert_response :success
  end

  test "should destroy sessao_caixa" do
    assert_difference("SessaoCaixa.count", -1) do
      delete sessao_caixa_url(@sessao_caixa), as: :json
    end

    assert_response :no_content
  end
end
