require "test_helper"

class LotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lote = lotes(:one)
  end

  test "should get index" do
    get lotes_url, as: :json
    assert_response :success
  end

  test "should create lote" do
    assert_difference("Lote.count") do
      post lotes_url, params: { lote: { data_entrada: @lote.data_entrada, data_validade: @lote.data_validade, preco_custo: @lote.preco_custo, produto_id: @lote.produto_id, quantidade_atual: @lote.quantidade_atual, quantidade_inicial: @lote.quantidade_inicial } }, as: :json
    end

    assert_response :created
  end

  test "should show lote" do
    get lote_url(@lote), as: :json
    assert_response :success
  end

  test "should update lote" do
    patch lote_url(@lote), params: { lote: { data_entrada: @lote.data_entrada, data_validade: @lote.data_validade, preco_custo: @lote.preco_custo, produto_id: @lote.produto_id, quantidade_atual: @lote.quantidade_atual, quantidade_inicial: @lote.quantidade_inicial } }, as: :json
    assert_response :success
  end

  test "should destroy lote" do
    assert_difference("Lote.count", -1) do
      delete lote_url(@lote), as: :json
    end

    assert_response :no_content
  end
end
