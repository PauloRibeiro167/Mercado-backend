require "test_helper"

class PromocaosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @promocao = promocaos(:one)
  end

  test "should get index" do
    get promocaos_url, as: :json
    assert_response :success
  end

  test "should create promocao" do
    assert_difference("Promocao.count") do
      post promocaos_url, params: { promocao: { data_fim: @promocao.data_fim, data_inicio: @promocao.data_inicio, preco_promocional: @promocao.preco_promocional, produto_id: @promocao.produto_id, tipo_promocao: @promocao.tipo_promocao } }, as: :json
    end

    assert_response :created
  end

  test "should show promocao" do
    get promocao_url(@promocao), as: :json
    assert_response :success
  end

  test "should update promocao" do
    patch promocao_url(@promocao), params: { promocao: { data_fim: @promocao.data_fim, data_inicio: @promocao.data_inicio, preco_promocional: @promocao.preco_promocional, produto_id: @promocao.produto_id, tipo_promocao: @promocao.tipo_promocao } }, as: :json
    assert_response :success
  end

  test "should destroy promocao" do
    assert_difference("Promocao.count", -1) do
      delete promocao_url(@promocao), as: :json
    end

    assert_response :no_content
  end
end
