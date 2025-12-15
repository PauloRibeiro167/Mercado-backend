require "test_helper"

class MovimentacaoCaixasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movimentacao_caixa = movimentacao_caixas(:one)
  end

  test "should get index" do
    get movimentacao_caixas_url, as: :json
    assert_response :success
  end

  test "should create movimentacao_caixa" do
    assert_difference("MovimentacaoCaixa.count") do
      post movimentacao_caixas_url, params: { movimentacao_caixa: { caixa_id: @movimentacao_caixa.caixa_id, data: @movimentacao_caixa.data, descricao: @movimentacao_caixa.descricao, origem_id: @movimentacao_caixa.origem_id, origem_type: @movimentacao_caixa.origem_type, sessao_caixa_id: @movimentacao_caixa.sessao_caixa_id, tipo: @movimentacao_caixa.tipo, usuario_id: @movimentacao_caixa.usuario_id, valor: @movimentacao_caixa.valor } }, as: :json
    end

    assert_response :created
  end

  test "should show movimentacao_caixa" do
    get movimentacao_caixa_url(@movimentacao_caixa), as: :json
    assert_response :success
  end

  test "should update movimentacao_caixa" do
    patch movimentacao_caixa_url(@movimentacao_caixa), params: { movimentacao_caixa: { caixa_id: @movimentacao_caixa.caixa_id, data: @movimentacao_caixa.data, descricao: @movimentacao_caixa.descricao, origem_id: @movimentacao_caixa.origem_id, origem_type: @movimentacao_caixa.origem_type, sessao_caixa_id: @movimentacao_caixa.sessao_caixa_id, tipo: @movimentacao_caixa.tipo, usuario_id: @movimentacao_caixa.usuario_id, valor: @movimentacao_caixa.valor } }, as: :json
    assert_response :success
  end

  test "should destroy movimentacao_caixa" do
    assert_difference("MovimentacaoCaixa.count", -1) do
      delete movimentacao_caixa_url(@movimentacao_caixa), as: :json
    end

    assert_response :no_content
  end
end
