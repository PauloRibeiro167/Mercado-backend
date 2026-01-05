class Api::V1::EstoquesController < ApplicationController
before_action :set_estoque, only: %i[ show update destroy ]

rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Estoque não encontrado" } ] }, status: :not_found
end

# GET /estoques
def index
  @estoques = Estoque.all
  render json: @estoques.map { |estoque| format_estoque_json(estoque) }
end

# GET /estoques/1
def show
  render json: format_estoque_json(@estoque)
end

# POST /estoques
def create
  @estoque = Estoque.new(estoque_params)

  if @estoque.save
    render json: format_estoque_json(@estoque), status: :created, location: @estoque
  else
    render_errors(@estoque)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# PATCH/PUT /estoques/1
def update
  if @estoque.update(estoque_params)
    render json: format_estoque_json(@estoque)
  else
    render_errors(@estoque)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# DELETE /estoques/1
def destroy
  @estoque.destroy!
  render json: { success: true, message: "Estoque removido com sucesso" }, status: :ok
end

private

  def set_estoque
    @estoque = Estoque.find(params.require(:id))
  end

  def estoque_params
    params.require(:estoque).permit(
      :produto_id,
      :lote_id,
      :quantidade_atual,
      :quantidade_minima,
      :quantidade_ideal,
      :media_vendas_diarias,
      :localizacao,
      :ultima_atualizacao
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
        { campo: "tipo", mensagem: "valor inválido para tipo" }
      ]
    }, status: :unprocessable_entity
  end

  def format_estoque_json(estoque)
    {
      id: estoque.id,
      quantidade_atual: estoque.quantidade_atual,
      quantidade_minima: estoque.quantidade_minima,
      quantidade_ideal: estoque.quantidade_ideal,
      media_vendas_diarias: estoque.media_vendas_diarias,
      localizacao: estoque.localizacao,
      ultima_atualizacao: estoque.ultima_atualizacao,
      created_at: estoque.created_at,
      updated_at: estoque.updated_at,
      produto: {
        id: estoque.produto&.id,
        nome: estoque.produto&.nome,
        preco: estoque.produto&.preco,
        preco_custo: estoque.produto&.preco_custo,
        unidade_medida: estoque.produto&.unidade_medida,
        descricao: estoque.produto&.descricao,
        ativo: estoque.produto&.ativo,
        categoria: {
          nome: estoque.produto&.categoria&.nome
        }
      },
      lote: estoque.lote ? {
        id: estoque.lote.id,
        codigo: estoque.lote.codigo,
        data_validade: estoque.lote.data_validade,
        preco_custo: estoque.lote.preco_custo
      } : nil
    }
  end
end
