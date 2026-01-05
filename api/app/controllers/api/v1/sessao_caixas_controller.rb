class Api::V1::SessaoCaixasController < ApplicationController
before_action :set_sessao_caixa, only: %i[ show update destroy ]

rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Sessão de caixa não encontrada" } ] }, status: :not_found
end

# GET /sessao_caixas
def index
  @sessao_caixas = SessaoCaixa.includes(:usuario_abertura).all
  render json: @sessao_caixas.map { |sessao| format_sessao_caixa_json(sessao) }
end

# GET /sessao_caixas/1
def show
  render json: format_sessao_caixa_json(@sessao_caixa)
end

# POST /sessao_caixas
def create
  @sessao_caixa = SessaoCaixa.new(sessao_caixa_params)

  if @sessao_caixa.save
    render json: format_sessao_caixa_json(@sessao_caixa), status: :created, location: @sessao_caixa
  else
    render_errors(@sessao_caixa)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# PATCH/PUT /sessao_caixas/1
def update
  if @sessao_caixa.update(sessao_caixa_params)
    render json: format_sessao_caixa_json(@sessao_caixa)
  else
    render_errors(@sessao_caixa)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# DELETE /sessao_caixas/1
def destroy
  @sessao_caixa.destroy!
  render json: { success: true, message: "Sessão de caixa removida com sucesso" }, status: :ok
end

private

  def set_sessao_caixa
    @sessao_caixa = SessaoCaixa.find(params.require(:id))
  end

  def sessao_caixa_params
    params.require(:sessao_caixa).permit(:usuario_id, :abertura, :valor_inicial, :fechamento, :valor_final, :saldo_esperado, :diferenca)
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

  def render_invalid_enum(_error)
    render json: {
      success: false,
      errors: [
        { campo: "status", mensagem: "valor inválido para status" }
      ]
    }, status: :unprocessable_entity
  end

  def format_sessao_caixa_json(sessao)
    {
      id: sessao.id,
      usuario_abertura_id: sessao.usuario_abertura_id,
      abertura: sessao.abertura,
      valor_inicial: sessao.valor_inicial,
      fechamento: sessao.fechamento,
      valor_final: sessao.valor_final,
      saldo_esperado: sessao.saldo_esperado,
      diferenca: sessao.diferenca,
      usuario: {
        id: sessao.usuario_abertura&.id,
        nome: "#{sessao.usuario_abertura&.primeiro_nome} #{sessao.usuario_abertura&.ultimo_nome}".strip,
        email: sessao.usuario_abertura&.email
      },
      created_at: sessao.created_at,
      updated_at: sessao.updated_at
    }
  end
end
