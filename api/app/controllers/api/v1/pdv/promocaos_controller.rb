class Api::V1::Pdv::PromocaosController < ApplicationController
before_action :set_promocao, only: %i[ show update destroy ]

rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Promoção não encontrada" } ] }, status: :not_found
end

# GET /promocaos
def index
    ultimo_atualizado = Promocao.maximum(:updated_at)
    
    if stale?(last_modified: ultimo_atualizado)
      @promocaos = Promocao.includes(:produto).all
      render json: @promocaos.map { |item| format_promocao_json(item) }
    end
  end

  # GET /promocaos/sync
  def sync
    data_ultima_sincronizacao = params[:desde]
    
    unless data_ultima_sincronizacao.present?
      render json: { success: false, errors: ["O parâmetro 'desde' é obrigatório"] }, status: :bad_request
      return
    end
    
    @promocaos_alterados = Promocao.includes(:produto).where('updated_at > ?', data_ultima_sincronizacao)
    
    render json: {
      sucesso: true,
      data_sincronizacao_atual: Time.current,
      atualizados: @promocaos_alterados.map { |item| format_promocao_json(item) }
    }
  end

# GET /promocaos/1
def show
  render json: format_promocao_json(@promocao)
end

# POST /promocaos
def create
  @promocao = Promocao.new(promocao_params)

  if @promocao.save
    render json: format_promocao_json(@promocao), status: :created, location: @promocao
  else
    render_errors(@promocao)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# PATCH/PUT /promocaos/1
def update
  if @promocao.update(promocao_params)
    render json: format_promocao_json(@promocao)
  else
    render_errors(@promocao)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# DELETE /promocaos/1
def destroy
  @promocao.destroy!
  render json: { success: true, message: "Promoção removida com sucesso" }, status: :ok
end

private

  def set_promocao
    @promocao = Promocao.find(params.require(:id))
  end

  def promocao_params
    params.require(:promocao).permit(:produto_id, :tipo_promocao, :preco_promocional, :data_inicio, :data_fim)
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
        { campo: "tipo_promocao", mensagem: "valor inválido para tipo_promocao" }
      ]
    }, status: :unprocessable_entity
  end

  def format_promocao_json(promocao)
    {
      id: promocao.id,
      produto_id: promocao.produto_id,
      tipo_promocao: promocao.tipo_promocao,
      preco_promocional: promocao.preco_promocional,
      data_inicio: promocao.data_inicio,
      data_fim: promocao.data_fim,
      produto: {
        id: promocao.produto&.id,
        nome: promocao.produto&.nome,
        preco: promocao.produto&.preco
      },
      created_at: promocao.created_at,
      updated_at: promocao.updated_at
    }
  end
end
