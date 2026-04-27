class Api::V1::Admin::PermissaosController < ApplicationController
before_action :set_permissao, only: %i[ show update destroy ]

rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Permissão não encontrada" } ] }, status: :not_found
end

# GET /permissaos
def index
  @permissaos = Admin::Permissao.all
  render json: @permissaos.map { |permissao| format_permissao_json(permissao) }
end

# GET /permissaos/1
def show
  render json: format_permissao_json(@permissao)
end

# POST /permissaos
def create
  @permissao = Admin::Permissao.new(permissao_params)

  if @permissao.save
    render json: format_permissao_json(@permissao), status: :created, location: @permissao
  else
    render_errors(@permissao)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# PATCH/PUT /permissaos/1
def update
  if @permissao.update(permissao_params)
    render json: format_permissao_json(@permissao)
  else
    render_errors(@permissao)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# DELETE /permissaos/1
def destroy
  @permissao.destroy!
  render json: { success: true, message: "Permissão removida com sucesso" }, status: :ok
end

private

  def set_permissao
    @permissao = Admin::Permissao.find(params.require(:id))
  end

  def permissao_params
    params.require(:permissao).permit(:nome, :chave_acao)
  end

  def render_errors(record)
    errors = record.errors.map do |error|
      { campo: error.attribute.to_s, mensagem: error.message }
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

  def format_permissao_json(permissao)
    {
      id: permissao.id,
      nome: permissao.nome,
      chave_acao: permissao.chave_acao,
      created_at: permissao.created_at,
      updated_at: permissao.updated_at
    }
  end
end
