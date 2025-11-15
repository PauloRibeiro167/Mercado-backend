class MetodoPagamentosController < ApplicationController
  before_action :set_metodo_pagamento, only: %i[ show update destroy ]

  # GET /metodo_pagamentos
  def index
    @metodo_pagamentos = MetodoPagamento.all

    render json: @metodo_pagamentos
  end

  # GET /metodo_pagamentos/1
  def show
    render json: @metodo_pagamento
  end

  # POST /metodo_pagamentos
  def create
    @metodo_pagamento = MetodoPagamento.new(metodo_pagamento_params)

    if @metodo_pagamento.save
      render json: @metodo_pagamento, status: :created, location: @metodo_pagamento
    else
      render json: @metodo_pagamento.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /metodo_pagamentos/1
  def update
    if @metodo_pagamento.update(metodo_pagamento_params)
      render json: @metodo_pagamento
    else
      render json: @metodo_pagamento.errors, status: :unprocessable_content
    end
  end

  # DELETE /metodo_pagamentos/1
  def destroy
    @metodo_pagamento.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metodo_pagamento
      @metodo_pagamento = MetodoPagamento.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def metodo_pagamento_params
      params.expect(metodo_pagamento: [ :nome, :taxa_percentual, :taxa_fixa, :ativo ])
    end
end
