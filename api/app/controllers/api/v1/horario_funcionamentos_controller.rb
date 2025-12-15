module Api
  module V1
    class HorarioFuncionamentosController < ApplicationController
  before_action :set_horario_funcionamento, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Horário de funcionamento não encontrado" } ] }, status: :not_found
  end

  # GET /horario_funcionamentos
  def index
    @horario_funcionamentos = HorarioFuncionamento.all
    render json: @horario_funcionamentos.map { |horario_funcionamento| format_horario_funcionamento_json(horario_funcionamento) }
  end

  # GET /horario_funcionamentos/1
  def show
    render json: format_horario_funcionamento_json(@horario_funcionamento)
  end

  # POST /horario_funcionamentos
  def create
    @horario_funcionamento = HorarioFuncionamento.new(horario_funcionamento_params)

    if @horario_funcionamento.save
      render json: format_horario_funcionamento_json(@horario_funcionamento), status: :created, location: @horario_funcionamento
    else
      render_errors(@horario_funcionamento)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # PATCH/PUT /horario_funcionamentos/1
  def update
    if @horario_funcionamento.update(horario_funcionamento_params)
      render json: format_horario_funcionamento_json(@horario_funcionamento)
    else
      render_errors(@horario_funcionamento)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # DELETE /horario_funcionamentos/1
  def destroy
    @horario_funcionamento.destroy!
    render json: { success: true, message: "Horário de funcionamento removido com sucesso" }, status: :ok
  end

  private

    def set_horario_funcionamento
      @horario_funcionamento = HorarioFuncionamento.find(params.require(:id))
    end

    def horario_funcionamento_params
      params.require(:horario_funcionamento).permit(:dia_semana, :data_especial, :hora_inicio, :hora_fim, :tipo, :ativo, :observacao)
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
          { campo: "tipo", mensagem: "valor inválido para tipo" }
        ]
      }, status: :unprocessable_entity
    end

    def format_horario_funcionamento_json(horario_funcionamento)
      {
        id: horario_funcionamento.id,
        dia_semana: horario_funcionamento.dia_semana,
        data_especial: horario_funcionamento.data_especial,
        hora_inicio: horario_funcionamento.hora_inicio,
        hora_fim: horario_funcionamento.hora_fim,
        tipo: horario_funcionamento.tipo,
        ativo: horario_funcionamento.ativo,
        observacao: horario_funcionamento.observacao,
        created_at: horario_funcionamento.created_at,
        updated_at: horario_funcionamento.updated_at
      }
    end
end

  end
end
