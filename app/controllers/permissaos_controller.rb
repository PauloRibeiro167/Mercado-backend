class PermissaosController < ApplicationController
  before_action :set_permissao, only: %i[ show update destroy ]

  # GET /permissaos
  def index
    @permissaos = Permissao.all

    render json: @permissaos
  end

  # GET /permissaos/1
  def show
    render json: @permissao
  end

  # POST /permissaos
  def create
    @permissao = Permissao.new(permissao_params)

    if @permissao.save
      render json: @permissao, status: :created, location: @permissao
    else
      render json: @permissao.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /permissaos/1
  def update
    if @permissao.update(permissao_params)
      render json: @permissao
    else
      render json: @permissao.errors, status: :unprocessable_content
    end
  end

  # DELETE /permissaos/1
  def destroy
    @permissao.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permissao
      @permissao = Permissao.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def permissao_params
      params.expect(permissao: [ :nome, :chave_acao ])
    end
end
