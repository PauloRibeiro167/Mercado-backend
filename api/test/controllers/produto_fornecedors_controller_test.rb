require "test_helper"

class ProdutoFornecedorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @produto_fornecedor = produto_fornecedors(:one)
  end

  test "should get index" do
    get produto_fornecedors_url, as: :json
    assert_response :success
  end

  test "should create produto_fornecedor" do
    assert_difference("ProdutoFornecedor.count") do
      post produto_fornecedors_url, params: { produto_fornecedor: { ativo: @produto_fornecedor.ativo, codigo_fornecedor: @produto_fornecedor.codigo_fornecedor, fornecedor_id: @produto_fornecedor.fornecedor_id, prazo_entrega_dias: @produto_fornecedor.prazo_entrega_dias, preco_custo: @produto_fornecedor.preco_custo, produto_id: @produto_fornecedor.produto_id, usuario_id: @produto_fornecedor.usuario_id } }, as: :json
    end

    assert_response :created
  end

  test "should show produto_fornecedor" do
    get produto_fornecedor_url(@produto_fornecedor), as: :json
    assert_response :success
  end

  test "should update produto_fornecedor" do
    patch produto_fornecedor_url(@produto_fornecedor), params: { produto_fornecedor: { ativo: @produto_fornecedor.ativo, codigo_fornecedor: @produto_fornecedor.codigo_fornecedor, fornecedor_id: @produto_fornecedor.fornecedor_id, prazo_entrega_dias: @produto_fornecedor.prazo_entrega_dias, preco_custo: @produto_fornecedor.preco_custo, produto_id: @produto_fornecedor.produto_id, usuario_id: @produto_fornecedor.usuario_id } }, as: :json
    assert_response :success
  end

  test "should destroy produto_fornecedor" do
    assert_difference("ProdutoFornecedor.count", -1) do
      delete produto_fornecedor_url(@produto_fornecedor), as: :json
    end

    assert_response :no_content
  end
end
