class Api::V1::Admin::PerfilsController < ApplicationController
before_action :set_perfil, only: %i[ show update destroy ]

rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Perfil não encontrado" } ] }, status: :not_found
end

# GET /perfils
def index
    ultimo_atualizado = Admin::Perfil.maximum(:updated_at)
    
    if stale?(last_modified: ultimo_atualizado)
      @perfils = Admin::Perfil.all
      render json: @perfils.map { |item| format_perfil_json(item) }
    end
  end

  # GET /perfils/sync
  def sync
    data_ultima_sincronizacao = params[:desde]
    
    unless data_ultima_sincronizacao.present?
      render json: { success: false, errors: ["O parâmetro 'desde' é obrigatório"] }, status: :bad_request
      return
    end
    
    @perfils_alterados = Admin::Perfil.where('updated_at > ?', data_ultima_sincronizacao)
    
    render json: {
      sucesso: true,
      data_sincronizacao_atual: Time.current,
      atualizados: @perfils_alterados.map { |item| format_perfil_json(item) }
    }
  end

# GET /perfils/1
def show
  render json: format_perfil_json(@perfil)
end

# POST /perfils
def create
  @perfil = Admin::Perfil.new(perfil_params)

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
    @perfil = Admin::Perfil.find(params.require(:id))
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
