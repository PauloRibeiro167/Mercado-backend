module Api
  module V1
    class UsuariosController < ApplicationController
  before_action :set_usuario, only: %i[ show update destroy ]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Usuário não encontrado" } ] }, status: :not_found
  end

  # GET /usuarios
  def index
    @usuarios = policy_scope(Usuario)
    render json: @usuarios
  end

  # GET /usuarios/1
  def show
    authorize @usuario
    render json: @usuario
  end

  # POST /usuarios
  def create
    @usuario = Usuario.new(usuario_params)
    authorize @usuario

    if @usuario.save
      render json: @usuario, status: :created, location: @usuario
    else
      render_errors(@usuario)
    end
  end

  # PATCH/PUT /usuarios/1
  def update
    authorize @usuario
    if @usuario.update(usuario_params)
      render json: @usuario
    else
      render_errors(@usuario)
    end
  end

  # DELETE /usuarios/1
  def destroy
    authorize @usuario
    @usuario.destroy!
    render json: { success: true, message: "Usuário removido com sucesso" }, status: :ok
  end

  private

    def set_usuario
      @usuario = Usuario.find(params.require(:id))
    end

    def usuario_params
      params.require(:usuario).permit(:nome, :email, :password, :password_confirmation)
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
end

  end
end
