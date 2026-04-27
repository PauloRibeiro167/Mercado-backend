module Estoque
  class CalculadoraDePrecoService
    def initialize(categoria, preco_base)
      @categoria = categoria
      @preco_base = preco_base
    end

    def calcular
      return nil if @preco_base.nil?

      base = @preco_base.to_d
      margem = (@categoria.taxa_de_lucro || 0).to_d / 100
      base * (1 + margem) + (@categoria.imposto || 0).to_d
    end
  end
end
