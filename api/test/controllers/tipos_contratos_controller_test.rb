require "test_helper"

class TiposContratosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipos_contrato = tipos_contratos(:one)
  end

  test "should get index" do
    get tipos_contratos_url, as: :json
    assert_response :success
  end

  test "should create tipos_contrato" do
    assert_difference("TiposContrato.count") do
      post tipos_contratos_url, params: { tipos_contrato: { ativo: @tipos_contrato.ativo, descricao: @tipos_contrato.descricao, nome: @tipos_contrato.nome } }, as: :json
    end

    assert_response :created
  end

  test "should show tipos_contrato" do
    get tipos_contrato_url(@tipos_contrato), as: :json
    assert_response :success
  end

  test "should update tipos_contrato" do
    patch tipos_contrato_url(@tipos_contrato), params: { tipos_contrato: { ativo: @tipos_contrato.ativo, descricao: @tipos_contrato.descricao, nome: @tipos_contrato.nome } }, as: :json
    assert_response :success
  end

  test "should destroy tipos_contrato" do
    assert_difference("TiposContrato.count", -1) do
      delete tipos_contrato_url(@tipos_contrato), as: :json
    end

    assert_response :no_content
  end
end
