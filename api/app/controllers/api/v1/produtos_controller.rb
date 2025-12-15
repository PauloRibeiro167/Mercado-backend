module Api
  module V1
    class ProdutosController < ApplicationController
  before_action :set_produto, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Produto não encontrado" } ] }, status: :not_found
  end

  # GET /produtos
  def index
    @produtos = Produto.includes(:categoria, :lotes).all
    render json: @produtos.map { |produto| format_produto_json(produto) }
  end

  # GET /produtos/1
  def show
    render json: format_produto_json(@produto)
  end

  # POST /produtos
  def create
    @produto = Produto.new(produto_params)

    if @produto.save
      render json: format_produto_json(@produto), status: :created, location: @produto
    else
      render_errors(@produto)
    end
  end

  # PATCH/PUT /produtos/1
  def update
    if @produto.update(produto_params)
      render json: format_produto_json(@produto)
    else
      render_errors(@produto)
    end
  end

  # DELETE /produtos/1
  def destroy
    @produto.destroy!
    render json: { success: true, message: "Produto removido com sucesso" }, status: :ok
  end

  private

    def set_produto
      @produto = Produto.find(params.require(:id))
    end

    def produto_params
      params.require(:produto).permit(:nome, :descricao, :preco, :codigo_barras, :unidade_medida, :marca, :ativo, :categoria_id, :estoque_minimo, :localizacao)
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

    def format_produto_json(produto)
      {
        id: produto.id,
        nome: produto.nome,
        descricao: produto.descricao,
        preco: produto.preco,
        codigo_barras: produto.codigo_barras,
        unidade_medida: produto.unidade_medida,
        marca: produto.marca,
        ativo: produto.ativo,
        categoria_id: produto.categoria_id,
        estoque_minimo: produto.estoque_minimo,
        localizacao: produto.localizacao,
        estoque_total: produto.estoque_total,
        valor_estoque: produto.valor_estoque,
        status_estoque: produto.status_estoque,
        categoria: {
          id: produto.categoria&.id,
          nome: produto.categoria&.nome,
          descricao: produto.categoria&.descricao
        },
        lotes: produto.lotes.map do |lote|
          {
            id: lote.id,
            quantidade_atual: lote.quantidade_atual,
            quantidade_inicial: lote.quantidade_inicial,
            preco_custo: lote.preco_custo,
            data_validade: lote.data_validade,
            data_entrada: lote.data_entrada,
            dias_para_vencer: lote.dias_para_vencer
          }
        end,
        created_at: produto.created_at,
        updated_at: produto.updated_at
      }
    end
end

  end
end
