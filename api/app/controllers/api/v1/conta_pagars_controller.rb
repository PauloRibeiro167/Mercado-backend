# Controller responsável por gerenciar contas a pagar via API.
# Fornece endpoints para CRUD de contas a pagar, incluindo listagem, criação, atualização e exclusão.
class Api::V1::ContaPagarsController < ApplicationController
  before_action :set_conta_pagar, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Conta a pagar não encontrada" } ] }, status: :not_found
  end

  # Retorna a lista de todas as contas a pagar formatadas em JSON.
  #
  # @return [String] JSON contendo um array de contas a pagar com detalhes formatados e status HTTP 200
  # GET /api/v1/conta_pagars
  def index
  @conta_pagars = ContaPagar.all
  render json: @conta_pagars.map { |conta_pagar| format_conta_pagar_json(conta_pagar) }
  end

  # Retorna os detalhes de uma conta a pagar específica.
  #
  # @return [String] JSON contendo os detalhes da conta a pagar formatada e status HTTP 200
  # GET /api/v1/conta_pagars/1
  def show
  render json: format_conta_pagar_json(@conta_pagar)
  end

  # Cria uma nova conta a pagar.
  #
  # @note Parâmetros esperados no corpo da requisição (chave :conta_pagar):
  #   - fornecedor_id [Integer] ID do fornecedor (opcional)
  #   - pedido_compra_id [Integer] ID do pedido de compra (opcional)
  #   - descricao [String] Descrição da conta
  #   - valor [Decimal] Valor da conta
  #   - data_vencimento [Date] Data de vencimento
  #   - data_pagamento [Date] Data do pagamento (opcional)
  #   - status [String] Status da conta (ex: 'pendente', 'paga')
  #
  # @return [String] JSON contendo a conta criada (status 201) ou erros de validação (status 422)
  # POST /api/v1/conta_pagars
  def create
  @conta_pagar = ContaPagar.new(conta_pagar_params)

  if @conta_pagar.save
    render json: format_conta_pagar_json(@conta_pagar), status: :created, location: @conta_pagar
  else
    render_errors(@conta_pagar)
  end
  rescue ArgumentError => e
  render_invalid_enum(e)
  end

  # Atualiza uma conta a pagar existente.
  #
  # @return [String] JSON contendo a conta atualizada (status 200) ou erros de validação (status 422)
  # PATCH/PUT /api/v1/conta_pagars/1
  def update
  if @conta_pagar.update(conta_pagar_params)
    render json: format_conta_pagar_json(@conta_pagar)
  else
    render_errors(@conta_pagar)
  end
  rescue ArgumentError => e
  render_invalid_enum(e)
  end

  # Remove uma conta a pagar.
  #
  # @return [String] JSON confirmando a remoção (status 200)
  # DELETE /api/v1/conta_pagars/1
  def destroy
  @conta_pagar.destroy!
  render json: { success: true, message: "Conta a pagar removida com sucesso" }, status: :ok
  end

  private

  # Localiza a conta a pagar através do ID enviado nos parâmetros.
  #
  # @return [ContaPagar] A conta encontrada
  def set_conta_pagar
    @conta_pagar = ContaPagar.find(params.require(:id))
  end

  # Define os parâmetros permitidos para criação e atualização da conta.
  #
  # @return [ActionController::Parameters] Parâmetros filtrados
  def conta_pagar_params
    params.require(:conta_pagar).permit(:fornecedor_id, :pedido_compra_id, :descricao, :valor, :data_vencimento, :data_pagamento, :status)
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

  # Renderiza erro para valores inválidos de enum (ex: status).
  #
  # @param _error [ArgumentError] O erro de enum inválido (não usado)
  # @return [void]
  def render_invalid_enum(_error)
    render json: {
      success: false,
      errors: [
        { campo: "status", mensagem: "valor inválido para status" }
      ]
    }, status: :unprocessable_entity
  end

  # Formata uma conta a pagar para resposta JSON.
  #
  # @param conta_pagar [ContaPagar] A conta a ser formatada
  # @return [Hash] Hash com os dados formatados da conta
  def format_conta_pagar_json(conta_pagar)
    {
      id: conta_pagar.id,
      descricao: conta_pagar.descricao,
      valor: conta_pagar.valor,
      data_vencimento: conta_pagar.data_vencimento,
      data_pagamento: conta_pagar.data_pagamento,
      status: conta_pagar.status,
      created_at: conta_pagar.created_at,
      updated_at: conta_pagar.updated_at,
      fornecedor: conta_pagar.fornecedor ? {
        nome: conta_pagar.fornecedor.nome
      } : nil,
      pedido_compra: conta_pagar.pedido_compra ? {
        id: conta_pagar.pedido_compra.id
      } : nil,
      metodo_pagamento: {
        nome: conta_pagar.metodo_pagamento&.nome
      },
      usuario: {
        email: conta_pagar.usuario&.email,
        nome: "#{conta_pagar.usuario&.primeiro_nome} #{conta_pagar.usuario&.ultimo_nome}".strip
      },
      categoria: {
        nome: conta_pagar.categoria&.nome
      }
    }
  end
end
