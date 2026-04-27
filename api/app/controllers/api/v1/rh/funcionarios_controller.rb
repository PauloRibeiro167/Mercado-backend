class Api::V1::Rh::FuncionariosController < ApplicationController
before_action :set_funcionario, only: %i[ show update destroy ]

rescue_from ActiveRecord::RecordNotFound do
  render json: { success: false, errors: [ { campo: :id, mensagem: "Funcionário não encontrado" } ] }, status: :not_found
end

# GET /funcionarios
def index
    ultimo_atualizado = Funcionario.maximum(:updated_at)
    
    if stale?(last_modified: ultimo_atualizado)
      @funcionarios = Funcionario.all
      render json: @funcionarios.map { |item| format_funcionario_json(item) }
    end
  end

  # GET /funcionarios/sync
  def sync
    data_ultima_sincronizacao = params[:desde]
    
    unless data_ultima_sincronizacao.present?
      render json: { success: false, errors: ["O parâmetro 'desde' é obrigatório"] }, status: :bad_request
      return
    end
    
    @funcionarios_alterados = Funcionario.where('updated_at > ?', data_ultima_sincronizacao)
    
    render json: {
      sucesso: true,
      data_sincronizacao_atual: Time.current,
      atualizados: @funcionarios_alterados.map { |item| format_funcionario_json(item) }
    }
  end

# GET /funcionarios/1
def show
  render json: format_funcionario_json(@funcionario)
end

# POST /funcionarios
def create
  @funcionario = Funcionario.new(funcionario_params)

  if @funcionario.save
    render json: format_funcionario_json(@funcionario), status: :created, location: @funcionario
  else
    render_errors(@funcionario)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# PATCH/PUT /funcionarios/1
def update
  if @funcionario.update(funcionario_params)
    render json: format_funcionario_json(@funcionario)
  else
    render_errors(@funcionario)
  end
rescue ArgumentError => e
  render_invalid_enum(e)
end

# DELETE /funcionarios/1
def destroy
  @funcionario.destroy!
  render json: { success: true, message: "Funcionário removido com sucesso" }, status: :ok
end

private

  def set_funcionario
    @funcionario = Funcionario.find(params.require(:id))
  end

  def funcionario_params
    params.require(:funcionario).permit(:nome, :cargo, :usuario_id)
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
        { campo: "tipo", mensagem: "valor inválido para tipo" }
      ]
    }, status: :unprocessable_entity
  end

  def format_funcionario_json(funcionario)
    {
      id: funcionario.id,
      nome: funcionario.nome,
      cpf: funcionario.cpf,
      data_nascimento: funcionario.data_nascimento,
      data_admissao: funcionario.data_admissao,
      salario: funcionario.salario,
      jornada_diaria_horas: funcionario.jornada_diaria_horas,
      duracao_pausa_minutos: funcionario.duracao_pausa_minutos,
      ativo: funcionario.ativo,
      created_at: funcionario.created_at,
      updated_at: funcionario.updated_at,
      cargo: {
        nome: funcionario.cargo&.nome
      },
      usuario: {
        email: funcionario.usuario&.email,
        nome: "#{funcionario.usuario&.primeiro_nome} #{funcionario.usuario&.ultimo_nome}".strip
      },
      tipos_contrato: {
        nome: funcionario.tipos_contrato&.nome
      }
    }
  end
end
