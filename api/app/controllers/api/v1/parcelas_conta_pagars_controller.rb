class Api::V1::ParcelasContaPagarsController < ApplicationController
  before_action :set_parcelas_conta_pagar, only: %i[ show update destroy ]

  # Retorna a lista de todas as parcelas de contas a pagar
  #
  # @return [String] JSON contendo um array de parcelas e status HTTP 200
  # GET /parcelas_conta_pagars
  def index
    @parcelas_conta_pagars = ParcelaContaPagar.all

    render json: @parcelas_conta_pagars
  end

  # Retorna os detalhes de uma parcela específica
  #
  # @return [String] JSON contendo os detalhes da parcela e status HTTP 200
  # GET /parcelas_conta_pagars/1
  def show
    render json: @parcelas_conta_pagar
  end

  # Cria uma nova parcela de conta a pagar
  #
  # @note Parâmetros esperados no corpo da requisição (chave :parcela_conta_pagar):
  #   - conta_pagar_id [Integer] ID da conta a pagar associada
  #   - numero_parcela [Integer] Número da parcela
  #   - valor [Decimal] Valor da parcela
  #   - data_vencimento [Date] Data de vencimento
  #   - paga [Boolean] Status de pagamento
  #   - data_pagamento [Date] Data do pagamento (opcional)
  #
  # @return [String] JSON contendo a parcela criada (status 201) ou erros de validação (status 422)
  # POST /parcelas_conta_pagars
  def create
    @parcelas_conta_pagar = ParcelaContaPagar.new(parcelas_conta_pagar_params)

    if @parcelas_conta_pagar.save
      render json: @parcelas_conta_pagar, status: :created, location: @parcelas_conta_pagar
    else
      render json: @parcelas_conta_pagar.errors, status: :unprocessable_content
    end
  end

  # Atualiza uma parcela existente
  #
  # @return [String] JSON contendo a parcela atualizada (status 200) ou erros de validação (status 422)
  # PATCH/PUT /parcelas_conta_pagars/1
  def update
    if @parcelas_conta_pagar.update(parcelas_conta_pagar_params)
      render json: @parcelas_conta_pagar
    else
      render json: @parcelas_conta_pagar.errors, status: :unprocessable_content
    end
  end

  # Remove uma parcela
  #
  # @return [void] Status HTTP 204 (No Content)
  # DELETE /parcelas_conta_pagars/1
  def destroy
    @parcelas_conta_pagar.destroy!
  end

  private
    # Localiza a parcela através do ID enviado nos parâmetros
    #
    # @return [ParcelaContaPagar] A parcela encontrada
    # Use callbacks to share common setup or constraints between actions.
    def set_parcelas_conta_pagar
      @parcelas_conta_pagar = ParcelaContaPagar.find(params.expect(:id))
    end

    # Define os parâmetros permitidos para criação e atualização da parcela
    #
    # @return [ActionController::Parameters] Parâmetros filtrados
    # Only allow a list of trusted parameters through.
    def parcelas_conta_pagar_params
      params.fetch(:parcela_conta_pagar, {}).permit(
        :conta_pagar_id,
        :numero_parcela,
        :valor,
        :data_vencimento,
        :paga,
        :data_pagamento
      )
    end
end
