require "test_helper"

class RegistroPontosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @registro_ponto = registro_pontos(:one)
  end

  test "should get index" do
    get registro_pontos_url, as: :json
    assert_response :success
  end

  test "should create registro_ponto" do
    assert_difference("RegistroPonto.count") do
      post registro_pontos_url, params: { registro_ponto: { aprovado: @registro_ponto.aprovado, data: @registro_ponto.data, funcionario_id: @registro_ponto.funcionario_id, hora_entrada: @registro_ponto.hora_entrada, hora_saida: @registro_ponto.hora_saida, horas_trabalhadas: @registro_ponto.horas_trabalhadas } }, as: :json
    end

    assert_response :created
  end

  test "should show registro_ponto" do
    get registro_ponto_url(@registro_ponto), as: :json
    assert_response :success
  end

  test "should update registro_ponto" do
    patch registro_ponto_url(@registro_ponto), params: { registro_ponto: { aprovado: @registro_ponto.aprovado, data: @registro_ponto.data, funcionario_id: @registro_ponto.funcionario_id, hora_entrada: @registro_ponto.hora_entrada, hora_saida: @registro_ponto.hora_saida, horas_trabalhadas: @registro_ponto.horas_trabalhadas } }, as: :json
    assert_response :success
  end

  test "should destroy registro_ponto" do
    assert_difference("RegistroPonto.count", -1) do
      delete registro_ponto_url(@registro_ponto), as: :json
    end

    assert_response :no_content
  end
end
