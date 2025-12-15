class PerfilsController < ApplicationController
  before_action :set_perfil, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Perfil não encontrado" } ] }, status: :not_found
  end

  # GET /perfils
  def index
    @perfils = Perfil.all
    render json: @perfils.map { |perfil| format_perfil_json(perfil) }
  end

  # GET /perfils/1
  def show
    render json: format_perfil_json(@perfil)
  end

  # POST /perfils
  def create
    @perfil = Perfil.new(perfil_params)

    if @perfil.save
      render json: format_perfil_json(@perfil), status: :created, location: @perfil
    else
      render_errors(@perfil)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # PATCH/PUT /perfils/1
  def update
    if @perfil.update(perfil_params)
      render json: format_perfil_json(@perfil)
    else
      render_errors(@perfil)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # DELETE /perfils/1
  def destroy
    @perfil.destroy!
    render json: { success: true, message: "Perfil removido com sucesso" }, status: :ok
  end

  private

    def set_perfil
      @perfil = Perfil.find(params.require(:id))
    end

    def perfil_params
      params.require(:perfil).permit(:nome, :descricao)
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

    def format_perfil_json(perfil)
      {
        id: perfil.id,
        nome: perfil.nome,
        descricao: perfil.descricao,
        created_at: perfil.created_at,
        updated_at: perfil.updated_at
      }
    end
end
