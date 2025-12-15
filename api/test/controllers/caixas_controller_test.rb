require "test_helper"

class CaixasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @caixa = caixas(:one)
  end

  test "should get index" do
    get caixas_url, as: :json
    assert_response :success
  end

  test "should create caixa" do
    assert_difference("Caixa.count") do
      post caixas_url, params: { caixa: { ativo: @caixa.ativo, nome: @caixa.nome, saldo: @caixa.saldo } }, as: :json
    end

    assert_response :created
  end

  test "should show caixa" do
    get caixa_url(@caixa), as: :json
    assert_response :success
  end

  test "should update caixa" do
    patch caixa_url(@caixa), params: { caixa: { ativo: @caixa.ativo, nome: @caixa.nome, saldo: @caixa.saldo } }, as: :json
    assert_response :success
  end

  test "should destroy caixa" do
    assert_difference("Caixa.count", -1) do
      delete caixa_url(@caixa), as: :json
    end

    assert_response :no_content
  end
end
