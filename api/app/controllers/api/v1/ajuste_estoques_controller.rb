Class Api::V1::AjusteEstoquesController < ApplicationController

  before_action :set_ajuste_estoque, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Ajuste de estoque não encontrado" } ] }, status: :not_found
  end

  # GET /ajuste_estoques
  def index
    @ajuste_estoques = AjusteEstoque.all
    render json: @ajuste_estoques.map { |ajuste| format_ajuste_json(ajuste) }
  end

  # GET /ajuste_estoques/1
  def show
    render json: format_ajuste_json(@ajuste_estoque)
  end

  # POST /ajuste_estoques
  def create
    @ajuste_estoque = AjusteEstoque.new(ajuste_estoque_params)

    if @ajuste_estoque.save
      render json: format_ajuste_json(@ajuste_estoque), status: :created, location: @ajuste_estoque
    else
      render_errors(@ajuste_estoque)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # PATCH/PUT /ajuste_estoques/1
  def update
    if @ajuste_estoque.update(ajuste_estoque_params)
      render json: format_ajuste_json(@ajuste_estoque)
    else
      render_errors(@ajuste_estoque)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # DELETE /ajuste_estoques/1
  def destroy
    @ajuste_estoque.destroy!
    render json: { success: true, message: "Ajuste de estoque removido com sucesso" }, status: :ok
  end

  private

    def set_ajuste_estoque
      @ajuste_estoque = AjusteEstoque.find(params.require(:id))
    end

    def ajuste_estoque_params
      params.require(:ajuste_estoque).permit(:lote_id, :usuario_id, :tipo, :quantidade, :motivo)
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

    def format_ajuste_json(ajuste)
      {
        id: ajuste.id,
        tipo: ajuste.tipo,
        quantidade: ajuste.quantidade,
        motivo: ajuste.motivo,
        created_at: ajuste.created_at,
        updated_at: ajuste.updated_at,
        lote: {
          codigo: ajuste.lote&.codigo,
          produto: {
            nome: ajuste.lote&.produto&.nome,
            preco: ajuste.lote&.produto&.preco,
            unidade_medida: ajuste.lote&.produto&.unidade_medida,
            descricao: ajuste.lote&.produto&.descricao
          }
        },
        usuario: {
          email: ajuste.usuario&.email,
          nome: "#{ajuste.usuario&.primeiro_nome} #{ajuste.usuario&.ultimo_nome}".strip
        }
      }
    end
