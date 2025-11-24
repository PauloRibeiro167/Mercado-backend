class CategoriaController < ApplicationController
  before_action :set_categoria, only: %i[ show update destroy ]

  # GET /categoria
  def index
    @categoria = Categoria.all

    render json: @categoria
  end

  # GET /categoria/1
  def show
    render json: @categoria
  end

  # POST /categoria
  def create
    @categoria = Categoria.new(categoria_params)

    if @categoria.save
      render json: @categoria, status: :created, location: @categoria
    else
      render json: @categoria.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /categoria/1
  def update
    if @categoria.update(categoria_params)
      render json: @categoria
    else
      render json: @categoria.errors, status: :unprocessable_content
    end
  end

  # DELETE /categoria/1
  def destroy
    @categoria.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_categoria
      @categoria = Categoria.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def categoria_params
      params.expect(categoria: [ :nome ])
    end
end
