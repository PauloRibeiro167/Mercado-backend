# Controller responsável pelo gerenciamento de cargos na API.
#
# Este controller fornece operações CRUD para a entidade Cargo, incluindo
# listagem, criação, visualização, atualização e exclusão de cargos.
# Inclui tratamento de erros para registros não encontrados e validações.
#
# @author [Nome do Autor]
# @since [Versão ou Data]
class Api::V1::CargosController < ApplicationController
  before_action :set_cargo, only: %i[show update destroy]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [{ campo: :id, mensagem: "Cargo não encontrado" }] }, status: :not_found
  end

  # Lista todos os cargos disponíveis.
  #
  # Retorna uma lista de todos os cargos no sistema, formatados em JSON.
  #
  # @return [JSON] uma lista de objetos JSON representando os cargos
  # @example
  #   GET /api/v1/cargos
  #   # Retorna: [{ "id": 1, "nome": "Gerente", ... }, ...]
  def index
    @cargos = Cargo.all
    render json: @cargos.map { |cargo| format_cargo_json(cargo) }
  end

  # Exibe os detalhes de um cargo específico.
  #
  # Retorna os detalhes completos de um cargo identificado pelo ID.
  #
  # @return [JSON] um objeto JSON com os detalhes do cargo
  # @return [JSON] erro 404 se o cargo não for encontrado
  # @example
  #   GET /api/v1/cargos/1
  #   # Retorna: { "id": 1, "nome": "Gerente", ... }
  def show
    render json: format_cargo_json(@cargo)
  end

  # Cria um novo cargo.
  #
  # Cria um novo cargo com os parâmetros fornecidos e retorna os detalhes se bem-sucedido.
  #
  # @return [JSON] um objeto JSON com os detalhes do cargo criado (status 201)
  # @return [JSON] erro 422 se houver erros de validação
  # @raise [ArgumentError] se o enum tipo for inválido
  # @example
  #   POST /api/v1/cargos
  #   {
  #     "cargo": {
  #       "nome": "Analista",
  #       "descricao": "Cargo de analista",
  #       "atribuicoes": "Análise de dados",
  #       "criado_por_id": 1
  #     }
  #   }
  def create
    @cargo = Cargo.new(cargo_params)

    if @cargo.save
      render json: format_cargo_json(@cargo), status: :created, location: @cargo
    else
      render_errors(@cargo)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # Atualiza um cargo existente.
  #
  # Atualiza os dados de um cargo identificado pelo ID com os parâmetros fornecidos.
  #
  # @return [JSON] um objeto JSON com os detalhes atualizados do cargo
  # @return [JSON] erro 422 se houver erros de validação
  # @return [JSON] erro 404 se o cargo não for encontrado
  # @raise [ArgumentError] se o enum tipo for inválido
  # @example
  #   PATCH /api/v1/cargos/1
  #   {
  #     "cargo": {
  #       "nome": "Gerente Sênior"
  #     }
  #   }
  def update
    if @cargo.update(cargo_params)
      render json: format_cargo_json(@cargo)
    else
      render_errors(@cargo)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # Remove um cargo.
  #
  # Exclui permanentemente um cargo identificado pelo ID.
  #
  # @return [JSON] confirmação de sucesso na exclusão
  # @return [JSON] erro 404 se o cargo não for encontrado
  # @example
  #   DELETE /api/v1/cargos/1
  #   # Retorna: { "success": true, "message": "Cargo removido com sucesso" }
  def destroy
    @cargo.destroy!
    render json: { success: true, message: "Cargo removido com sucesso" }, status: :ok
  end

  private

  # Define a instância do cargo baseada no ID fornecido nos parâmetros.
  #
  # @return [Cargo] a instância do cargo encontrada
  # @raise [ActiveRecord::RecordNotFound] se o cargo não existir
  # @private
  def set_cargo
    @cargo = Cargo.find(params.require(:id))
  end

  # Define os parâmetros permitidos para criação/atualização de cargo.
  #
  # @return [ActionController::Parameters] os parâmetros filtrados
  # @private
  def cargo_params
    params.require(:cargo).permit(:nome, :descricao, :atribuicoes, :criado_por_id)
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
        { campo: "tipo", mensagem: "valor inválido para tipo" }
      ]
    }, status: :unprocessable_entity
  end

  # Formata um cargo para resposta JSON.
  #
  # @param cargo [Cargo] a instância do cargo a ser formatada
  # @return [Hash] um hash com os dados do cargo formatados
  # @private
  def format_cargo_json(cargo)
    {
      id: cargo.id,
      nome: cargo.nome,
      descricao: cargo.descricao,
      atribuicoes: cargo.atribuicoes,
      created_at: cargo.created_at,
      updated_at: cargo.updated_at,
      criado_por: {
        email: cargo.criado_por&.email,
        nome: "#{cargo.criado_por&.primeiro_nome} #{cargo.criado_por&.ultimo_nome}".strip
      }
    }
  end
end
