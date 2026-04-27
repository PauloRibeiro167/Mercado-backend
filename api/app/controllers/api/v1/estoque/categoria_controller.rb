# Controller responsável pelo gerenciamento de categorias de produtos na API.
#
# Este controller fornece operações CRUD para a entidade Categoria, que funciona como
# tipos ou classes de produtos (ex.: "Laticínios", "Bebidas", etc.). Permite criar
# hierarquias com subcategorias, facilitando a organização e busca de produtos por tipo.
# Inclui tratamento de erros para registros não encontrados e validações de enum.
#
# @author [Nome do Autor]
# @since [Versão ou Data]
class Api::V1::Estoque::CategoriaController < ApplicationController
  before_action :set_categoria, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Categoria não encontrada" } ] }, status: :not_found
  end

  # Lista todas as categorias disponíveis.
  #
  # Retorna uma lista de todas as categorias no sistema, formatadas em JSON,
  # incluindo subcategorias e informações do criador.
  #
  # @return [JSON] uma lista de objetos JSON representando as categorias
  # @example
  #   GET /api/v1/categoria
  #   # Retorna: [{ "id": 1, "nome": "Laticínios", "categoria_pai": null, ... }, ...]
  def index
  @categorias = Categoria.all
  render json: @categorias.map { |categoria| format_categoria_json(categoria) }
  end

  # Exibe os detalhes de uma categoria específica.
  #
  # Retorna os detalhes completos de uma categoria identificada pelo ID,
  # incluindo informações da categoria pai e criador.
  #
  # @return [JSON] um objeto JSON com os detalhes da categoria
  # @return [JSON] erro 404 se a categoria não for encontrada
  # @example
  #   GET /api/v1/categoria/1
  #   # Retorna: { "id": 1, "nome": "Laticínios", "categoria_pai": null, ... }
  def show
  render json: format_categoria_json(@categoria)
  end

  # Cria uma nova categoria de produto.
  #
  # Cria uma nova categoria com os parâmetros fornecidos, permitindo definir
  # hierarquias (categoria pai) e configurações como taxa de lucro e imposto.
  #
  # @return [JSON] um objeto JSON com os detalhes da categoria criada (status 201)
  # @return [JSON] erro 422 se houver erros de validação
  # @raise [ArgumentError] se o enum status_da_categoria for inválido
  # @example
  #   POST /api/v1/categoria
  #   {
  #     "categoria": {
  #       "nome": "Laticínios",
  #       "descricao": "Produtos derivados do leite",
  #       "status_da_categoria": "disponivel",
  #       "taxa_de_lucro": 20,
  #       "imposto": 5.0,
  #       "categoria_pai_id": null,
  #       "criado_por_id": 1
  #     }
  #   }
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

  # Atualiza uma categoria existente.
  #
  # Atualiza os dados de uma categoria identificada pelo ID, permitindo alterar
  # nome, descrição, status, taxas e até mesmo a hierarquia (categoria pai).
  #
  # @return [JSON] um objeto JSON com os detalhes atualizados da categoria
  # @return [JSON] erro 422 se houver erros de validação
  # @return [JSON] erro 404 se a categoria não for encontrada
  # @raise [ArgumentError] se o enum status_da_categoria for inválido
  # @example
  #   PATCH /api/v1/categoria/1
  #   {
  #     "categoria": {
  #       "nome": "Produtos Lácteos",
  #       "taxa_de_lucro": 25
  #     }
  #   }
  def update
  if @categoria.update(categoria_params)
    render json: format_categoria_json(@categoria)
  else
    render_errors(@categoria)
  end
  rescue ArgumentError => e
  render_invalid_enum(e)
  end

  # Remove uma categoria.
  #
  # Exclui permanentemente uma categoria identificada pelo ID. Note que
  # subcategorias dependentes podem ser afetadas.
  #
  # @return [JSON] confirmação de sucesso na exclusão
  # @return [JSON] erro 404 se a categoria não for encontrada
  # @example
  #   DELETE /api/v1/categoria/1
  #   # Retorna: { "success": true, "message": "Categoria removida com sucesso" }
  def destroy
  @categoria.destroy!
  render json: { success: true, message: "Categoria removida com sucesso" }, status: :ok
  end

  private

  # Define a instância da categoria baseada no ID fornecido nos parâmetros.
  #
  # @return [Categoria] a instância da categoria encontrada
  # @raise [ActiveRecord::RecordNotFound] se a categoria não existir
  # @private
  def set_categoria
    @categoria = Categoria.find(params.require(:id))
  end

  # Define os parâmetros permitidos para criação/atualização de categoria.
  #
  # @return [ActionController::Parameters] os parâmetros filtrados
  # @private
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

  # Renderiza os erros de validação de um registro em formato JSON.
  #
  # @param record [ActiveRecord::Base] o registro com erros
  # @return [void] renderiza JSON com erros
  # @private
  def render_errors(record)
    errors = record.errors.map do |error|
      {
        campo: error.attribute.to_s,
        mensagem: error.message
      }
    end
    render json: { success: false, errors: errors }, status: :unprocessable_entity
  end

  # Renderiza erro para valor inválido de enum.
  #
  # @param _error [ArgumentError] o erro de argumento (não usado)
  # @return [void] renderiza JSON com erro de enum inválido
  # @private
  def render_invalid_enum(_error)
    render json: {
      success: false,
      errors: [
        { campo: "status_da_categoria", mensagem: "valor inválido para status_da_categoria" }
      ]
    }, status: :unprocessable_entity
  end

  # Formata uma categoria para resposta JSON.
  #
  # Inclui informações da categoria pai e criador para contexto completo.
  #
  # @param categoria [Categoria] a instância da categoria a ser formatada
  # @return [Hash] um hash com os dados da categoria formatados
  # @private
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
