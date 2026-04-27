module Rh
  class FolhaPagamento < ApplicationRecord
    belongs_to :funcionario
    belongs_to :usuario, class_name: 'Admin::Usuario'
    belongs_to :conta_pagar, optional: true

    # Validações
    validates :data_referencia,
              presence: { message: "Data de referência não pode ficar em branco" }

    validates :salario_base,
              numericality: { greater_than: 0, message: "Salário base deve ser maior que zero" }

    validates :dias_trabalhados,
              numericality: { greater_than: 0, message: "Dias trabalhados deve ser maior que zero" }

    validates :total_bruto,
              numericality: { greater_than_or_equal_to: 0, message: "Total bruto deve ser maior ou igual a zero" }

    validates :total_descontos,
              numericality: { greater_than_or_equal_to: 0, message: "Total descontos deve ser maior ou igual a zero" }

    validates :total_liquido,
              numericality: { greater_than_or_equal_to: 0, message: "Total líquido deve ser maior ou igual a zero" }

    # Assumindo jornada de 8 horas/dia, ajuste conforme necessário
    JORNADA_DIARIA = 8.0

    # Método para calcular horas trabalhadas e extras
    def calcular_horas
      registros = RegistroPonto.where(funcionario: funcionario, data: data_referencia.beginning_of_month..data_referencia.end_of_month)
      total_horas = registros.sum(:horas_trabalhadas)
      horas_extras = [ total_horas - (dias_trabalhados * JORNADA_DIARIA), 0 ].max

      update(
        horas_trabalhadas: total_horas,
        horas_extras: horas_extras,
        adicional_horas_extras: horas_extras * (salario_base / (dias_trabalhados * JORNADA_DIARIA) * 1.5)  # Exemplo de cálculo
      )
    end

    # Método para gerar conta a pagar (atualizado)
    def gerar_conta_pagar
      return if processada?

      calcular_horas  # Calcula antes de gerar

      conta = ContaPagar.create!(
        tipo_conta: "funcionario",
        descricao: "Pagamento #{funcionario.nome} - #{data_referencia.strftime('%B %Y')}",
        valor: total_liquido,
        data_vencimento: data_referencia.end_of_month,
        status: "pendente",
        usuario: usuario,
        categoria: Categoria.find_by(nome: "Salários")
      )

      update(conta_pagar: conta, processada: true)
    end
  end
end
