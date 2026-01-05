class Api::V1::CategoriaController < ApplicationController
  before_action :set_categoria, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Categoria não encontrada" } ] }, status: :not_found
  end

  # GET /categoria
  def index
  @categorias = Categoria.all
  render json: @categorias.map { |categoria| format_categoria_json(categoria) }
  end

  # GET /categoria/1
  def show
  render json: format_categoria_json(@categoria)
  end

  # POST /categoria
  def create
  @categoria = Categoria.new(categoria_params)

  if @categoria.save
    render json: format_categoria_json(@categoria), status: :created, location: @categoria
  else
    render_errors(@categoria)
  end
  rescue ArgumentError => e
  render_invalid_enum(e)
  end

  # PATCH/PUT /categoria/1
  def update
  if @categoria.update(categoria_params)
    render json: format_categoria_json(@categoria)
  else
    render_errors(@categoria)
  end
  rescue ArgumentError => e
  render_invalid_enum(e)
  end

  # DELETE /categoria/1
  def destroy
  @categoria.destroy!
  render json: { success: true, message: "Categoria removida com sucesso" }, status: :ok
  end

  private

  def set_categoria
    @categoria = Categoria.find(params.require(:id))
  end

  def categoria_params
    params.require(:categoria).permit(
      :nome,
      :descricao,
      :imagem,
      :status_da_categoria,
      :excluido,
      :taxa_de_lucro,
      :imposto,
      :ordem,
      :categoria_pai_id,
      :criado_por_id
    )
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
        { campo: "status_da_categoria", mensagem: "valor inválido para status_da_categoria" }
      ]
    }, status: :unprocessable_entity
  end

  def format_categoria_json(categoria)
    {
      id: categoria.id,
      nome: categoria.nome,
      descricao: categoria.descricao,
      imagem: categoria.imagem,
      status_da_categoria: categoria.status_da_categoria,
      excluido: categoria.excluido,
      taxa_de_lucro: categoria.taxa_de_lucro,
      imposto: categoria.imposto,
      ordem: categoria.ordem,
      created_at: categoria.created_at,
      updated_at: categoria.updated_at,
      categoria_pai: categoria.categoria_pai ? {
        id: categoria.categoria_pai.id,
        nome: categoria.categoria_pai.nome
      } : nil,
      criado_por: categoria.criado_por ? {
        email: categoria.criado_por.email,
        nome: "#{categoria.criado_por.primeiro_nome} #{categoria.criado_por.ultimo_nome}".strip
      } : nil
    }
  end
end
