module Api
  module V1
    class FornecedorsController < ApplicationController
  before_action :set_fornecedor, only: %i[ show update destroy produtos ]

  rescue_from ActiveRecord::RecordNotFound do
    render json: { success: false, errors: [ { campo: :id, mensagem: "Fornecedor não encontrado" } ] }, status: :not_found
  end

  # GET /fornecedors
  def index
    @fornecedors = Fornecedor.all
    render json: @fornecedors.map { |fornecedor| format_fornecedor_json(fornecedor) }
  end

  # GET /fornecedors/1
  def show
    render json: format_fornecedor_json(@fornecedor)
  end

  # POST /fornecedors
  def create
    @fornecedor = Fornecedor.new(fornecedor_params)

    if @fornecedor.save
      render json: format_fornecedor_json(@fornecedor), status: :created, location: @fornecedor
    else
      render_errors(@fornecedor)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # PATCH/PUT /fornecedors/1
  def update
    if @fornecedor.update(fornecedor_params)
      render json: format_fornecedor_json(@fornecedor)
    else
      render_errors(@fornecedor)
    end
  rescue ArgumentError => e
    render_invalid_enum(e)
  end

  # DELETE /fornecedors/1
  def destroy
    @fornecedor.destroy!
    render json: { success: true, message: "Fornecedor removido com sucesso" }, status: :ok
  end

  # GET /fornecedors/1/produtos
  def produtos
    @produtos = @fornecedor.produtos
    render json: @produtos.map { |produto| format_produto_json(produto) }
  end

  private

    def set_fornecedor
      @fornecedor = Fornecedor.find(params.require(:id))
    end

    def fornecedor_params
      params.require(:fornecedor).permit(:nome, :cnpj, :contato_nome, :telefone, :email)
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

    def format_fornecedor_json(fornecedor)
      {
        id: fornecedor.id,
        nome: fornecedor.nome,
        cnpj: fornecedor.cnpj,
        contato_nome: fornecedor.contato_nome,
        telefone: fornecedor.telefone,
        email: fornecedor.email,
        created_at: fornecedor.created_at,
        updated_at: fornecedor.updated_at,
        usuario: {
          email: fornecedor.usuario&.email,
          nome: "#{fornecedor.usuario&.primeiro_nome} #{fornecedor.usuario&.ultimo_nome}".strip
        },
        responsavel: {
          email: fornecedor.responsavel&.email,
          nome: "#{fornecedor.responsavel&.primeiro_nome} #{fornecedor.responsavel&.ultimo_nome}".strip
        }
      }
    end

    def format_produto_json(produto)
      {
        id: produto.id,
        nome: produto.nome,
        descricao: produto.descricao,
        preco_venda: produto.preco_venda,
        categoria_id: produto.categoria_id,
        created_at: produto.created_at,
        updated_at: produto.updated_at
      }
    end
end

  end
end
