class Api::V1::LotesController < ApplicationController
before_action :set_lote, only: %i[ show update destroy ]

rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Lote não encontrado" } ] }, status: :not_found
end

# GET /lotes
def index
  @lotes = Lote.all
  render json: @lotes.map { |lote| format_lote_json(lote) }
end

# GET /lotes/1
def show
  render json: format_lote_json(@lote)
end

# POST /lotes
def create
  @lote = Lote.new(lote_params)

  if @lote.save
    render json: format_lote_json(@lote), status: :created, location: @lote
  else
    render_errors(@lote)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# PATCH/PUT /lotes/1
def update
  if @lote.update(lote_params)
    render json: format_lote_json(@lote)
  else
    render_errors(@lote)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# DELETE /lotes/1
def destroy
  @lote.destroy!
  render json: { success: true, message: "Lote removido com sucesso" }, status: :ok
end

private

  def set_lote
    @lote = Lote.find(params.require(:id))
  end

  def lote_params
    params.require(:lote).permit(:produto_id, :quantidade_atual, :quantidade_inicial, :preco_custo, :data_validade, :data_entrada)
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

  def format_lote_json(lote)
    {
      id: lote.id,
      quantidade_atual: lote.quantidade_atual,
      quantidade_inicial: lote.quantidade_inicial,
      preco_custo: lote.preco_custo,
      data_validade: lote.data_validade,
      data_entrada: lote.data_entrada,
      created_at: lote.created_at,
      updated_at: lote.updated_at,
      produto: {
        nome: lote.produto&.nome,
        preco: lote.produto&.preco,
        unidade_medida: lote.produto&.unidade_medida,
        descricao: lote.produto&.descricao
      }
    }
  end
end
