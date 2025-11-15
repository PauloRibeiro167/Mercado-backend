class PromocaosController < ApplicationController
  before_action :set_promocao, only: %i[ show update destroy ]

  # GET /promocaos
  def index
    @promocaos = Promocao.all

    render json: @promocaos
  end

  # GET /promocaos/1
  def show
    render json: @promocao
  end

  # POST /promocaos
  def create
    @promocao = Promocao.new(promocao_params)

    if @promocao.save
      render json: @promocao, status: :created, location: @promocao
    else
      render json: @promocao.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /promocaos/1
  def update
    if @promocao.update(promocao_params)
      render json: @promocao
    else
      render json: @promocao.errors, status: :unprocessable_content
    end
  end

  # DELETE /promocaos/1
  def destroy
    @promocao.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_promocao
      @promocao = Promocao.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def promocao_params
      params.expect(promocao: [ :produto_id, :tipo_promocao, :preco_promocional, :data_inicio, :data_fim ])
    end
end
