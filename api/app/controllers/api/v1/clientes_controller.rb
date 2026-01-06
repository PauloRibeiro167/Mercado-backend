# Controller responsável pelo gerenciamento de clientes na API.
#
# Este controller fornece operações CRUD para a entidade Cliente, permitindo
# listar, criar, visualizar, atualizar e excluir clientes. Inclui validações
# de CPF, email e telefone, e tratamento de erros para registros não encontrados.
#
# @author [Nome do Autor]
# @since [Versão ou Data]
class Api::V1::ClientesController < ApplicationController
  before_action :set_cliente, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Cliente não encontrado" } ] }, status: :not_found
  end

  # Lista todos os clientes disponíveis.
  #
  # Retorna uma lista de todos os clientes no sistema, formatados em JSON.
  #
  # @return [JSON] uma lista de objetos JSON representando os clientes
  # @example
  #   GET /api/v1/clientes
  #   # Retorna: [{ "id": 1, "nome": "João Silva", "cpf": "123.456.789-00", ... }, ...]
  def index
    @clientes = Cliente.all
    render json: @clientes.map { |cliente| format_cliente_json(cliente) }
  end

  # Exibe os detalhes de um cliente específico.
  #
  # Retorna os detalhes completos de um cliente identificado pelo ID.
  #
  # @return [JSON] um objeto JSON com os detalhes do cliente
  # @return [JSON] erro 404 se o cliente não for encontrado
  # @example
  #   GET /api/v1/clientes/1
  #   # Retorna: { "id": 1, "nome": "João Silva", "cpf": "123.456.789-00", ... }
  def show
    render json: format_cliente_json(@cliente)
  end

  # Cria um novo cliente.
  #
  # Cria um novo cliente com os parâmetros fornecidos, validando CPF, email, etc.
  #
  # @return [JSON] um objeto JSON com os detalhes do cliente criado (status 201)
  # @return [JSON] erro 422 se houver erros de validação
  # @raise [ArgumentError] se houver enum inválido (não aplicável aqui)
  # @example
  #   POST /api/v1/clientes
  #   {
  #     "cliente": {
  #       "nome": "João Silva",
  #       "cpf": "123.456.789-00",
  #       "telefone": "(11) 99999-9999",
  #       "email": "joao@example.com"
  #     }
  #   }
  def create
    @cliente = Cliente.new(cliente_params)

    if @cliente.save
      render json: format_cliente_json(@cliente), status: :created, location: @cliente
    else
      render_errors(@cliente)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # Atualiza um cliente existente.
  #
  # Atualiza os dados de um cliente identificado pelo ID com os parâmetros fornecidos.
  #
  # @return [JSON] um objeto JSON com os detalhes atualizados do cliente
  # @return [JSON] erro 422 se houver erros de validação
  # @return [JSON] erro 404 se o cliente não for encontrado
  # @raise [ArgumentError] se houver enum inválido (não aplicável aqui)
  # @example
  #   PATCH /api/v1/clientes/1
  #   {
  #     "cliente": {
  #       "nome": "João Silva Santos"
  #     }
  #   }
  def update
    if @cliente.update(cliente_params)
      render json: format_cliente_json(@cliente)
    else
      render_errors(@cliente)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # Remove um cliente.
  #
  # Exclui permanentemente um cliente identificado pelo ID.
  #
  # @return [JSON] confirmação de sucesso na exclusão
  # @return [JSON] erro 404 se o cliente não for encontrado
  # @example
  #   DELETE /api/v1/clientes/1
  #   # Retorna: { "success": true, "message": "Cliente removido com sucesso" }
  def destroy
    @cliente.destroy!
    render json: { success: true, message: "Cliente removido com sucesso" }, status: :ok
  end

  private

  # Define a instância do cliente baseada no ID fornecido nos parâmetros.
  #
  # @return [Cliente] a instância do cliente encontrada
  # @raise [ActiveRecord::RecordNotFound] se o cliente não existir
  # @private
  def set_cliente
    @cliente = Cliente.find(params.require(:id))
  end

  # Define os parâmetros permitidos para criação/atualização de cliente.
  #
  # @return [ActionController::Parameters] os parâmetros filtrados
  # @private
  def cliente_params
    params.require(:cliente).permit(:nome, :cpf, :telefone, :email)
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

  # Formata um cliente para resposta JSON.
  #
  # @param cliente [Cliente] a instância do cliente a ser formatada
  # @return [Hash] um hash com os dados do cliente formatados
  # @private
  def format_cliente_json(cliente)
    {
      id: cliente.id,
      nome: cliente.nome,
      cpf: cliente.cpf,
      telefone: cliente.telefone,
      email: cliente.email,
      created_at: cliente.created_at,
      updated_at: cliente.updated_at
    }
  end
end
