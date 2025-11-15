class ContaRecebersController < ApplicationController
  before_action :set_conta_receber, only: %i[ show update destroy ]

  # GET /conta_recebers
  def index
    @conta_recebers = ContaReceber.all

    render json: @conta_recebers
  end

  # GET /conta_recebers/1
  def show
    render json: @conta_receber
  end

  # POST /conta_recebers
  def create
    @conta_receber = ContaReceber.new(conta_receber_params)

    if @conta_receber.save
      render json: @conta_receber, status: :created, location: @conta_receber
    else
      render json: @conta_receber.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /conta_recebers/1
  def update
    if @conta_receber.update(conta_receber_params)
      render json: @conta_receber
    else
      render json: @conta_receber.errors, status: :unprocessable_content
    end
  end

  # DELETE /conta_recebers/1
  def destroy
    @conta_receber.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conta_receber
      @conta_receber = ContaReceber.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def conta_receber_params
      params.expect(conta_receber: [ :venda_id, :cliente_id, :descricao, :valor, :data_vencimento, :data_recebimento, :status ])
    end
end
