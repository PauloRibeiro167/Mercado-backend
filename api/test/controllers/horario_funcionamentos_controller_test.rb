require "test_helper"

class HorarioFuncionamentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @horario_funcionamento = horario_funcionamentos(:one)
  end

  test "should get index" do
    get horario_funcionamentos_url, as: :json
    assert_response :success
  end

  test "should create horario_funcionamento" do
    assert_difference("HorarioFuncionamento.count") do
      post horario_funcionamentos_url, params: { horario_funcionamento: { ativo: @horario_funcionamento.ativo, data_especial: @horario_funcionamento.data_especial, dia_semana: @horario_funcionamento.dia_semana, hora_fim: @horario_funcionamento.hora_fim, hora_inicio: @horario_funcionamento.hora_inicio, observacao: @horario_funcionamento.observacao, tipo: @horario_funcionamento.tipo } }, as: :json
    end

    assert_response :created
  end

  test "should show horario_funcionamento" do
    get horario_funcionamento_url(@horario_funcionamento), as: :json
    assert_response :success
  end

  test "should update horario_funcionamento" do
    patch horario_funcionamento_url(@horario_funcionamento), params: { horario_funcionamento: { ativo: @horario_funcionamento.ativo, data_especial: @horario_funcionamento.data_especial, dia_semana: @horario_funcionamento.dia_semana, hora_fim: @horario_funcionamento.hora_fim, hora_inicio: @horario_funcionamento.hora_inicio, observacao: @horario_funcionamento.observacao, tipo: @horario_funcionamento.tipo } }, as: :json
    assert_response :success
  end

  test "should destroy horario_funcionamento" do
    assert_difference("HorarioFuncionamento.count", -1) do
      delete horario_funcionamento_url(@horario_funcionamento), as: :json
    end

    assert_response :no_content
  end
end
