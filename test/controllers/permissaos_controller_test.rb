require "test_helper"

class PermissaosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @permissao = permissaos(:one)
  end

  test "should get index" do
    get permissaos_url, as: :json
    assert_response :success
  end

  test "should create permissao" do
    assert_difference("Permissao.count") do
      post permissaos_url, params: { permissao: { chave_acao: @permissao.chave_acao, nome: @permissao.nome } }, as: :json
    end

    assert_response :created
  end

  test "should show permissao" do
    get permissao_url(@permissao), as: :json
    assert_response :success
  end

  test "should update permissao" do
    patch permissao_url(@permissao), params: { permissao: { chave_acao: @permissao.chave_acao, nome: @permissao.nome } }, as: :json
    assert_response :success
  end

  test "should destroy permissao" do
    assert_difference("Permissao.count", -1) do
      delete permissao_url(@permissao), as: :json
    end

    assert_response :no_content
  end
end
