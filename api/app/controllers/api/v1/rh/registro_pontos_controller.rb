class Api::V1::Rh::RegistroPontosController < ApplicationController
before_action :set_registro_ponto, only: %i[ show update destroy ]

rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Registro de ponto não encontrado" } ] }, status: :not_found
end

# GET /registro_pontos
def index
  @registro_pontos = RegistroPonto.includes(:funcionario).all
  render json: @registro_pontos.map { |registro| format_registro_ponto_json(registro) }
end

# GET /registro_pontos/1
def show
  render json: format_registro_ponto_json(@registro_ponto)
end

# POST /registro_pontos
def create
  @registro_ponto = RegistroPonto.new(registro_ponto_params)

  if @registro_ponto.save
    render json: format_registro_ponto_json(@registro_ponto), status: :created, location: @registro_ponto
  else
    render_errors(@registro_ponto)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# PATCH/PUT /registro_pontos/1
def update
  if @registro_ponto.update(registro_ponto_params)
    render json: format_registro_ponto_json(@registro_ponto)
  else
    render_errors(@registro_ponto)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# DELETE /registro_pontos/1
def destroy
  @registro_ponto.destroy!
  render json: { success: true, message: "Registro de ponto removido com sucesso" }, status: :ok
end

private

  def set_registro_ponto
    @registro_ponto = RegistroPonto.find(params.require(:id))
  end

  def registro_ponto_params
    params.require(:registro_ponto).permit(:funcionario_id, :data, :hora_entrada, :hora_saida, :horas_trabalhadas, :aprovado)
  end

  def render_errors(record)
    errors = record.errors.map do |error|
      {
        campo: error.attribute.to_s,
        mensagem: error.message
      }
    end
    render json: { success: false, errors: errors }, status: :unprocessable_entity
  end

  def render_invalid_enum(_error)
    render json: {
      success: false,
      errors: [
        { campo: "aprovado", mensagem: "valor inválido para aprovado" }
      ]
    }, status: :unprocessable_entity
  end

  def format_registro_ponto_json(registro)
    {
      id: registro.id,
      funcionario_id: registro.funcionario_id,
      data: registro.data,
      hora_entrada: registro.hora_entrada,
      hora_saida: registro.hora_saida,
      horas_trabalhadas: registro.horas_trabalhadas,
      aprovado: registro.aprovado,
      funcionario: {
        id: registro.funcionario&.id,
        nome: registro.funcionario&.nome,
        email: registro.funcionario&.email
      },
      created_at: registro.created_at,
      updated_at: registro.updated_at
    }
  end
end
