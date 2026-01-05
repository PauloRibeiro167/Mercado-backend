# Namespace para operações REST de caixas na API pública v1.
#
# @see Caixa
class Api::V1::CaixasController < ApplicationController
  before_action :set_caixa, only: %i[show update destroy]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [{ campo: :id, mensagem: "Caixa não encontrado" }] }, status: :not_found
  end

  # Lista todos os caixas com seus relacionamentos imediatos.
  #
  # @return [void]
  def index
    @caixas = Caixa.includes(:usuario, :sessao_caixas, :movimentacao_caixas).all
    render json: @caixas.map { |caixa| format_caixa_json(caixa) }
  end

  # Exibe um caixa específico com seus relacionamentos.
  #
  # @return [void]
  def show
    @caixa = Caixa.includes(:usuario, :sessao_caixas, :movimentacao_caixas).find(params.require(:id))
    render json: format_caixa_json(@caixa)
  end

  # Cria um novo caixa.
  #
  # @return [void]
  def create
    @caixa = Caixa.new(caixa_params)
    @caixa.usuario ||= current_user if defined?(current_user) && current_user

    if @caixa.save
      render json: format_caixa_json(@caixa), status: :created, location: @caixa
    else
      render_errors(@caixa)
    end
  end

  # Atualiza um caixa existente.
  #
  # @return [void]
  def update
    if @caixa.update(caixa_params)
      render json: format_caixa_json(@caixa)
    else
      render_errors(@caixa)
    end
  end

  # Remove um caixa existente.
  #
  # @return [void]
  def destroy
    @caixa.destroy!
    render json: { success: true, message: "Caixa removido com sucesso" }, status: :ok
  end

  private

  # Recupera o caixa com base no identificador requerido.
  #
  # @return [void]
  def set_caixa
    @caixa = Caixa.find(params.require(:id))
  end

  # Lista branca de parâmetros permitidos para caixas.
  #
  # @return [ActionController::Parameters]
  def caixa_params
    params.require(:caixa).permit(:nome, :saldo, :ativo, :usuario_id)
  end

  # Renderiza respostas de erro padronizadas.
  #
  # @param record [ActiveRecord::Base]
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

  # Constrói o JSON representativo de um caixa.
  #
  # @param caixa [Caixa]
  # @return [Hash]
  def format_caixa_json(caixa)
    {
      id: caixa.id,
      nome: caixa.nome,
      saldo: caixa.saldo,
      ativo: caixa.ativo,
      data_abertura: caixa.data_abertura,
      created_at: caixa.created_at,
      updated_at: caixa.updated_at,
      usuario: {
        id: caixa.usuario&.id,
        nome: "#{caixa.usuario&.primeiro_nome} #{caixa.usuario&.ultimo_nome}".strip
      },
      sessoes: {
        total: caixa.sessao_caixas.count,
        abertas: caixa.sessao_caixas.where(status: :aberta).count,
        fechadas: caixa.sessao_caixas.where(status: :fechada).count
      },
      movimentacoes: {
        total: caixa.movimentacao_caixas.count,
        entradas: caixa.movimentacao_caixas.where(tipo: "entrada").sum(:valor),
        saidas: caixa.movimentacao_caixas.where(tipo: "saida").sum(:valor),
        suprimentos: caixa.movimentacao_caixas.where(tipo: "suprimento").sum(:valor),
        sangrias: caixa.movimentacao_caixas.where(tipo: "sangria").sum(:valor)
      }
    }
  end
end
