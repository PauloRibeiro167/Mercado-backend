require "test_helper"

class EstoquesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @estoque = estoques(:one)
  end

  test "should get index" do
    get estoques_url, as: :json
    assert_response :success
  end

  test "should create estoque" do
    assert_difference("Estoque.count") do
      post estoques_url, params: { estoque: { localizacao: @estoque.localizacao, lote_id: @estoque.lote_id, media_vendas_diarias: @estoque.media_vendas_diarias, produto_id: @estoque.produto_id, quantidade_atual: @estoque.quantidade_atual, quantidade_ideal: @estoque.quantidade_ideal, quantidade_minima: @estoque.quantidade_minima, ultima_atualizacao: @estoque.ultima_atualizacao } }, as: :json
    end

    assert_response :created
  end

  test "should show estoque" do
    get estoque_url(@estoque), as: :json
    assert_response :success
  end

  test "should update estoque" do
    patch estoque_url(@estoque), params: { estoque: { localizacao: @estoque.localizacao, lote_id: @estoque.lote_id, media_vendas_diarias: @estoque.media_vendas_diarias, produto_id: @estoque.produto_id, quantidade_atual: @estoque.quantidade_atual, quantidade_ideal: @estoque.quantidade_ideal, quantidade_minima: @estoque.quantidade_minima, ultima_atualizacao: @estoque.ultima_atualizacao } }, as: :json
    assert_response :success
  end

  test "should destroy estoque" do
    assert_difference("Estoque.count", -1) do
      delete estoque_url(@estoque), as: :json
    end

    assert_response :no_content
  end
end
