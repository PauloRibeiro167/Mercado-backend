module Api
  module V1
    class ProdutoFornecedorsController < ApplicationController
  before_action :set_produto_fornecedor, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Produto-fornecedor não encontrado" } ] }, status: :not_found
  end

  # GET /produto_fornecedors
  def index
    @produto_fornecedors = ProdutoFornecedor.includes(:produto, :fornecedor).all
    render json: @produto_fornecedors.map { |produto_fornecedor| format_produto_fornecedor_json(produto_fornecedor) }
  end

  # GET /produto_fornecedors/1
  def show
    render json: format_produto_fornecedor_json(@produto_fornecedor)
  end

  # POST /produto_fornecedors
  def create
    @produto_fornecedor = ProdutoFornecedor.new(produto_fornecedor_params)

    if @produto_fornecedor.save
      render json: format_produto_fornecedor_json(@produto_fornecedor), status: :created, location: @produto_fornecedor
    else
      render_errors(@produto_fornecedor)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # PATCH/PUT /produto_fornecedors/1
  def update
    if @produto_fornecedor.update(produto_fornecedor_params)
      render json: format_produto_fornecedor_json(@produto_fornecedor)
    else
      render_errors(@produto_fornecedor)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # DELETE /produto_fornecedors/1
  def destroy
    @produto_fornecedor.destroy!
    render json: { success: true, message: "Produto-fornecedor removido com sucesso" }, status: :ok
  end

  private

    def set_produto_fornecedor
      @produto_fornecedor = ProdutoFornecedor.includes(:produto, :fornecedor).find(params.require(:id))
    end

    def produto_fornecedor_params
      params.require(:produto_fornecedor).permit(
        :produto_id,
        :fornecedor_id,
        :preco_custo,
        :prazo_entrega_dias,
        :codigo_fornecedor,
        :ativo,
        :usuario_id
      )
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

    def format_produto_fornecedor_json(produto_fornecedor)
      {
        id: produto_fornecedor.id,
        produto_id: produto_fornecedor.produto_id,
        fornecedor_id: produto_fornecedor.fornecedor_id,
        preco_custo: produto_fornecedor.preco_custo,
        prazo_entrega_dias: produto_fornecedor.prazo_entrega_dias,
        codigo_fornecedor: produto_fornecedor.codigo_fornecedor,
        ativo: produto_fornecedor.ativo,
        usuario_id: produto_fornecedor.usuario_id,
        created_at: produto_fornecedor.created_at,
        updated_at: produto_fornecedor.updated_at,
        produto: {
          nome: produto_fornecedor.produto&.nome
        },
        fornecedor: {
          nome: produto_fornecedor.fornecedor&.nome
        }
      }
    end
end

  end
end
