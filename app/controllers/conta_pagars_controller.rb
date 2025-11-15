class ContaPagarsController < ApplicationController
  before_action :set_conta_pagar, only: %i[ show update destroy ]

  # GET /conta_pagars
  def index
    @conta_pagars = ContaPagar.all

    render json: @conta_pagars
  end

  # GET /conta_pagars/1
  def show
    render json: @conta_pagar
  end

  # POST /conta_pagars
  def create
    @conta_pagar = ContaPagar.new(conta_pagar_params)

    if @conta_pagar.save
      render json: @conta_pagar, status: :created, location: @conta_pagar
    else
      render json: @conta_pagar.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /conta_pagars/1
  def update
    if @conta_pagar.update(conta_pagar_params)
      render json: @conta_pagar
    else
      render json: @conta_pagar.errors, status: :unprocessable_content
    end
  end

  # DELETE /conta_pagars/1
  def destroy
    @conta_pagar.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conta_pagar
      @conta_pagar = ContaPagar.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def conta_pagar_params
      params.expect(conta_pagar: [ :fornecedor_id, :pedido_compra_id, :descricao, :valor, :data_vencimento, :data_pagamento, :status ])
    end
end
