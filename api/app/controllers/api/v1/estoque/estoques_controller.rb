# Controller responsável por gerenciar estoques via API.
# Fornece endpoints para CRUD de estoques, incluindo listagem, criação, atualização e exclusão.
class Api::V1::Estoque::EstoquesController < ApplicationController
  before_action :set_estoque, only: %i[show update destroy]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [{ campo: :id, mensagem: "Estoque não encontrado" }] }, status: :not_found
  end

  # Retorna a lista de todos os estoques formatados em JSON.
  #
  # @return [String] JSON contendo um array de estoques com detalhes formatados e status HTTP 200
  # GET /api/v1/estoques
  def index
    @estoques = Estoque.all
    render json: @estoques.map { |estoque| format_estoque_json(estoque) }
  end

  # Retorna os detalhes de um estoque específico.
  #
  # @return [String] JSON contendo os detalhes do estoque formatado e status HTTP 200
  # GET /api/v1/estoques/1
  def show
    render json: format_estoque_json(@estoque)
  end

  # Cria um novo estoque.
  #
  # @note Parâmetros esperados no corpo da requisição (chave :estoque):
  #   - produto_id [Integer] ID do produto associado
  #   - lote_id [Integer] ID do lote associado (opcional)
  #   - quantidade_atual [Integer] Quantidade atual
  #   - quantidade_minima [Integer] Quantidade mínima (opcional)
  #   - quantidade_ideal [Integer] Quantidade ideal (opcional)
  #   - media_vendas_diarias [Decimal] Média de vendas diárias (opcional)
  #   - localizacao [String] Localização (opcional)
  #   - ultima_atualizacao [DateTime] Última atualização (opcional)
  #
  # @return [String] JSON contendo o estoque criado (status 201) ou erros de validação (status 422)
  # POST /api/v1/estoques
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

  # Atualiza um estoque existente.
  #
  # @return [String] JSON contendo o estoque atualizado (status 200) ou erros de validação (status 422)
  # PATCH/PUT /api/v1/estoques/1
  def update
    if @estoque.update(estoque_params)
      render json: format_estoque_json(@estoque)
    else
      render_errors(@estoque)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # Remove um estoque.
  #
  # @return [String] JSON confirmando a remoção (status 200)
  # DELETE /api/v1/estoques/1
  def destroy
    @estoque.destroy!
    render json: { success: true, message: "Estoque removido com sucesso" }, status: :ok
  end

  private

  # Localiza o estoque através do ID enviado nos parâmetros.
  #
  # @return [Estoque] O estoque encontrado
  def set_estoque
    @estoque = Estoque.find(params.require(:id))
  end

  # Define os parâmetros permitidos para criação e atualização do estoque.
  #
  # @return [ActionController::Parameters] Parâmetros filtrados
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

  # Renderiza erros de validação em formato JSON padronizado.
  #
  # @param record [ActiveRecord::Base] O registro com erros
  # @return [void]
  def render_errors(record)
    errors = record.errors.map do |error|
      {
        campo: error.attribute.to_s,
        mensagem: error.message
      }
    end
    render json: { success: false, errors: errors }, status: :unprocessable_entity
  end

  # Renderiza erro para valores inválidos de enum.
  #
  # @param _error [ArgumentError] O erro de enum inválido (não usado)
  # @return [void]
  def render_invalid_enum(_error)
    render json: {
      success: false,
      errors: [
        { campo: "tipo", mensagem: "valor inválido para tipo" }
      ]
    }, status: :unprocessable_entity
  end

  # Formata um estoque para resposta JSON.
  #
  # @param estoque [Estoque] O estoque a ser formatado
  # @return [Hash] Hash com os dados formatados do estoque
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
