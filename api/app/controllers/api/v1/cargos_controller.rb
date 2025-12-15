module Api
  module V1
    class CargosController < ApplicationController
  before_action :set_cargo, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Cargo não encontrado" } ] }, status: :not_found
  end

  # GET /cargos
  def index
    @cargos = Cargo.all
    render json: @cargos.map { |cargo| format_cargo_json(cargo) }
  end

  # GET /cargos/1
  def show
    render json: format_cargo_json(@cargo)
  end

  # POST /cargos
  def create
    @cargo = Cargo.new(cargo_params)

    if @cargo.save
      render json: format_cargo_json(@cargo), status: :created, location: @cargo
    else
      render_errors(@cargo)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # PATCH/PUT /cargos/1
  def update
    if @cargo.update(cargo_params)
      render json: format_cargo_json(@cargo)
    else
      render_errors(@cargo)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # DELETE /cargos/1
  def destroy
    @cargo.destroy!
    render json: { success: true, message: "Cargo removido com sucesso" }, status: :ok
  end

  private

    def set_cargo
      @cargo = Cargo.find(params.require(:id))
    end

    def cargo_params
      params.require(:cargo).permit(:nome, :descricao, :atribuicoes, :criado_por_id)
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

    def format_cargo_json(cargo)
      {
        id: cargo.id,
        nome: cargo.nome,
        descricao: cargo.descricao,
        atribuicoes: cargo.atribuicoes,
        created_at: cargo.created_at,
        updated_at: cargo.updated_at,
        criado_por: {
          email: cargo.criado_por&.email,
          nome: "#{cargo.criado_por&.primeiro_nome} #{cargo.criado_por&.ultimo_nome}".strip
        }
      }
    end
end

  end
end
