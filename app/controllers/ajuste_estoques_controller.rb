class AjusteEstoquesController < ApplicationController
  before_action :set_ajuste_estoque, only: %i[ show update destroy ]

  # GET /ajuste_estoques
  def index
    @ajuste_estoques = AjusteEstoque.all

    render json: @ajuste_estoques
  end

  # GET /ajuste_estoques/1
  def show
    render json: @ajuste_estoque
  end

  # POST /ajuste_estoques
  def create
    @ajuste_estoque = AjusteEstoque.new(ajuste_estoque_params)

    if @ajuste_estoque.save
      render json: @ajuste_estoque, status: :created, location: @ajuste_estoque
    else
      render json: @ajuste_estoque.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /ajuste_estoques/1
  def update
    if @ajuste_estoque.update(ajuste_estoque_params)
      render json: @ajuste_estoque
    else
      render json: @ajuste_estoque.errors, status: :unprocessable_content
    end
  end

  # DELETE /ajuste_estoques/1
  def destroy
    @ajuste_estoque.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ajuste_estoque
      @ajuste_estoque = AjusteEstoque.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def ajuste_estoque_params
      params.expect(ajuste_estoque: [ :lote_id, :usuario_id, :tipo, :quantidade, :motivo ])
    end
end
