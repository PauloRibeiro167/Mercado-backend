class Api::V1::Admin::UsuariosController < ApplicationController
  before_action :set_usuario, only: %i[ show update destroy ]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Usuário não encontrado" } ] }, status: :not_found
  end

  # GET /usuarios
  def index
    ultimo_atualizado = policy_scope(Admin::Usuario).maximum(:updated_at)
    
    if stale?(last_modified: ultimo_atualizado)
      @usuarios = policy_scope(Admin::Usuario)
      render json: @usuarios
    end
  end

  # GET /usuarios/sync
  def sync
    data_ultima_sincronizacao = params[:desde]
    
    unless data_ultima_sincronizacao.present?
      render json: { success: false, errors: ["O parâmetro 'desde' é obrigatório"] }, status: :bad_request
      return
    end
    
    @usuarios_alterados = policy_scope(Admin::Usuario).where('updated_at > ?', data_ultima_sincronizacao)
    
    render json: {
      sucesso: true,
      data_sincronizacao_atual: Time.current,
      atualizados: @usuarios_alterados
    }
  end

  # GET /usuarios/1
  def show
    authorize @usuario
    render json: @usuario
  end

  # POST /usuarios
  def create
    @usuario = Admin::Usuario.new(usuario_params)
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
    @usuario = Admin::Usuario.find(params.require(:id))
  end

  def usuario_params
    params.require(:usuario).permit(:primeiro_nome, :ultimo_nome, :email, :senha, :senha_confirmation, :role_id, :status)
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
