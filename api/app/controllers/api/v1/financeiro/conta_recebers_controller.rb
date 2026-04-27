# Controller responsável por gerenciar contas a receber via API.
# Fornece endpoints para CRUD de contas a receber, incluindo listagem, criação, atualização e exclusão.
class Api::V1::Financeiro::ContaRecebersController < ApplicationController
  before_action :set_conta_receber, only: %i[show update destroy]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Conta a receber não encontrada" } ] }, status: :not_found
  end

  # Retorna a lista de todas as contas a receber formatadas em JSON.
  #
  # @return [String] JSON contendo um array de contas a receber com detalhes formatados e status HTTP 200
  # GET /api/v1/conta_recebers
  def index
    @conta_recebers = ContaReceber.all
    render json: @conta_recebers.map { |conta_receber| format_conta_receber_json(conta_receber) }
  end

  # Retorna os detalhes de uma conta a receber específica.
  #
  # @return [String] JSON contendo os detalhes da conta a receber formatada e status HTTP 200
  # GET /api/v1/conta_recebers/1
  def show
    render json: format_conta_receber_json(@conta_receber)
  end

  # Cria uma nova conta a receber.
  #
  # @note Parâmetros esperados no corpo da requisição (chave :conta_receber):
  #   - venda_id [Integer] ID da venda associada (opcional)
  #   - cliente_id [Integer] ID do cliente associado (opcional)
  #   - descricao [String] Descrição da conta
  #   - valor [Decimal] Valor da conta
  #   - data_vencimento [Date] Data de vencimento
  #   - data_recebimento [Date] Data do recebimento (opcional)
  #   - status [String] Status da conta (ex: 'pendente', 'pago', 'atrasado')
  #
  # @return [String] JSON contendo a conta criada (status 201) ou erros de validação (status 422)
  # POST /api/v1/conta_recebers
  def create
    @conta_receber = ContaReceber.new(conta_receber_params)

    if @conta_receber.save
      render json: format_conta_receber_json(@conta_receber), status: :created, location: @conta_receber
    else
      render_errors(@conta_receber)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # Atualiza uma conta a receber existente.
  #
  # @return [String] JSON contendo a conta atualizada (status 200) ou erros de validação (status 422)
  # PATCH/PUT /api/v1/conta_recebers/1
  def update
    if @conta_receber.update(conta_receber_params)
      render json: format_conta_receber_json(@conta_receber)
    else
      render_errors(@conta_receber)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # Remove uma conta a receber.
  #
  # @return [String] JSON confirmando a remoção (status 200)
  # DELETE /api/v1/conta_recebers/1
  def destroy
    @conta_receber.destroy!
    render json: { success: true, message: "Conta a receber removida com sucesso" }, status: :ok
  end

  private

  # Localiza a conta a receber através do ID enviado nos parâmetros.
  #
  # @return [ContaReceber] A conta encontrada
  def set_conta_receber
    @conta_receber = ContaReceber.find(params.require(:id))
  end

  # Define os parâmetros permitidos para criação e atualização da conta.
  #
  # @return [ActionController::Parameters] Parâmetros filtrados
  def conta_receber_params
    params.require(:conta_receber).permit(:venda_id, :cliente_id, :descricao, :valor, :data_vencimento, :data_recebimento, :status)
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

  # Formata uma conta a receber para resposta JSON.
  #
  # @param conta_receber [ContaReceber] A conta a ser formatada
  # @return [Hash] Hash com os dados formatados da conta
  def format_conta_receber_json(conta_receber)
    {
      id: conta_receber.id,
      descricao: conta_receber.descricao,
      valor: conta_receber.valor,
      data_vencimento: conta_receber.data_vencimento,
      data_recebimento: conta_receber.data_recebimento,
      status: conta_receber.status,
      created_at: conta_receber.created_at,
      updated_at: conta_receber.updated_at,
      venda: conta_receber.venda ? {
        id: conta_receber.venda.id
      } : nil,
      cliente: conta_receber.cliente ? {
        nome: conta_receber.cliente.nome
      } : nil,
      metodo_pagamento: {
        nome: conta_receber.metodo_pagamento&.nome
      },
      usuario: {
        email: conta_receber.usuario&.email,
        nome: "#{conta_receber.usuario&.primeiro_nome} #{conta_receber.usuario&.ultimo_nome}".strip
      },
      categoria: {
        nome: conta_receber.categoria&.nome
      }
    }
  end
end
