# model de ajustes de estoque.
#
# Esta Model lida com ajustes no estoque de inventário, incluindo entradas, saídas e ajustes.
# Pertence a um lote (lote) e obrigatoriamente a um usuario (usuário).
# 
# sempre que houver uma divergencia de dados dentro do estoque, as mudanças devem ser registradas para questões de auditoria
#
# @attr lote [Lote] o lote associado ao ajuste dentro do estoque.
# @attr usuario [Usuario] o usuário associado
# @attr tipo [String] o tipo de ajuste ('entrada', 'saida', 'ajuste')
# @attr quantidade [Integer] a quantidade ajustada
class AjusteEstoque < ApplicationRecord
  belongs_to :lote
  belongs_to :usuario

  # Define o tipo de ajuste de estoque: entrada (entrada), saida (saída), ajuste (ajuste)
  enum :tipo, %i[entrada saida ajuste]

  # Validações
  validates :tipo,
            presence: { message: "Tipo não pode ficar em branco" }

  validates :quantidade,
            presence: { message: "Quantidade não pode ficar em branco" },
            numericality: { only_integer: true, greater_than: 0, message: "Quantidade deve ser um número inteiro maior que zero" }

  validates :usuario,
            presence: { message: "Usuário não pode ficar em branco" }

  # Define o tipo padrão como :entrada se não fornecido durante a inicialização.
  after_initialize :set_tipo_default, if: -> { tipo.nil? }

  # Callbacks para atualizar o estoque
  after_save :atualizar_estoque
  before_destroy :reverter_estoque

  private

  # Define o tipo padrão como :entrada se não definido.
  # @return [void]
  def set_tipo_default
    self.tipo ||= :entrada
  end

  # Atualiza a quantidade do estoque com base no tipo de ajuste.
  # @return [void]
  def atualizar_estoque
    delta = tipo == "entrada" ? quantidade : -quantidade
    lote.estoque&.ajustar_quantidade(delta)
  end

  # Reverte a quantidade do estoque quando o ajuste é destruído.
  # @return [void]
  def reverter_estoque
    delta = tipo == "entrada" ? -quantidade : quantidade
    lote.estoque&.ajustar_quantidade(delta)
  end
end
