class ClientesController < ApplicationController
  before_action :set_cliente, only: %i[ show update destroy ]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Cliente não encontrado" } ] }, status: :not_found
  end

  # GET /clientes
  def index
    @clientes = Cliente.all
    render json: @clientes.map { |cliente| format_cliente_json(cliente) }
  end

  # GET /clientes/1
  def show
    render json: format_cliente_json(@cliente)
  end

  # POST /clientes
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

  # PATCH/PUT /clientes/1
  def update
    if @cliente.update(cliente_params)
      render json: format_cliente_json(@cliente)
    else
      render_errors(@cliente)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # DELETE /clientes/1
  def destroy
    @cliente.destroy!
    render json: { success: true, message: "Cliente removido com sucesso" }, status: :ok
  end

  private

    def set_cliente
      @cliente = Cliente.find(params.require(:id))
    end

    def cliente_params
      params.require(:cliente).permit(:nome, :cpf, :telefone, :email)
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
