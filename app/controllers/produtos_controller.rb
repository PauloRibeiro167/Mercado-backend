class ProdutosController < ApplicationController
  before_action :set_produto, only: %i[ show update destroy ]

  # GET /produtos
  def index
    @produtos = Produto.includes(:categoria).all

    # Estrutura de resposta padronizada
    response_data = {
      success: true,
      data: @produtos.as_json(
        include: {
          categoria: { only: [:id, :nome] }
        },
        methods: [:estoque_total, :valor_estoque]
      ),
      meta: {
        total_count: @produtos.count,
        timestamp: Time.current.iso8601
      }
    }

    render json: response_data
  end

  # GET /produtos/1
  def show
    response_data = {
      success: true,
      data: @produto.as_json(
        include: {
          categoria: { only: [:id, :nome, :descricao] },
          lotes: {
            only: [:id, :quantidade_atual, :quantidade_inicial, :preco_custo, :data_validade, :data_entrada],
            methods: [:dias_para_vencer]
          }
        },
        methods: [:estoque_total, :valor_estoque, :status_estoque]
      ),
      meta: {
        timestamp: Time.current.iso8601
      }
    }

    render json: response_data
  end

  # POST /produtos
  def create
    @produto = Produto.new(produto_params)

    if @produto.save
      response_data = {
        success: true,
        message: 'Produto criado com sucesso',
        data: @produto.as_json(
          include: {
            categoria: { only: [:id, :nome] }
          }
        ),
        meta: {
          timestamp: Time.current.iso8601
        }
      }
      render json: response_data, status: :created, location: @produto
    else
      response_data = {
        success: false,
        message: 'Erro ao criar produto',
        errors: @produto.errors.full_messages,
        meta: {
          timestamp: Time.current.iso8601
        }
      }
      render json: response_data, status: :unprocessable_content
    end
  end

  # PATCH/PUT /produtos/1
  def update
    if @produto.update(produto_params)
      response_data = {
        success: true,
        message: 'Produto atualizado com sucesso',
        data: @produto.as_json(
          include: {
            categoria: { only: [:id, :nome] }
          }
        ),
        meta: {
          timestamp: Time.current.iso8601
        }
      }
      render json: response_data
    else
      response_data = {
        success: false,
        message: 'Erro ao atualizar produto',
        errors: @produto.errors.full_messages,
        meta: {
          timestamp: Time.current.iso8601
        }
      }
      render json: response_data, status: :unprocessable_content
    end
  end

  # DELETE /produtos/1
  def destroy
    if @produto.destroy
      response_data = {
        success: true,
        message: 'Produto excluído com sucesso',
        meta: {
          timestamp: Time.current.iso8601
        }
      }
      render json: response_data
    else
      response_data = {
        success: false,
        message: 'Erro ao excluir produto',
        errors: @produto.errors.full_messages,
        meta: {
          timestamp: Time.current.iso8601
        }
      }
      render json: response_data, status: :unprocessable_content
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_produto
      @produto = Produto.includes(:categoria, :lotes).find(params.expect(:id))
    rescue ActiveRecord::RecordNotFound
      response_data = {
        success: false,
        message: 'Produto não encontrado',
        meta: {
          timestamp: Time.current.iso8601
        }
      }
      render json: response_data, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def produto_params
      params.expect(produto: [ :nome, :descricao, :preco, :codigo_barras, :unidade_medida, :marca, :ativo, :categoria_id, :estoque_minimo, :localizacao ])
    end
end
