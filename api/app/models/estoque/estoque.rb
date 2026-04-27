module Estoque
  # Modelo que representa o estoque de um produto.
  # Gerencia quantidades atuais, mínimas e ideais, além de calcular médias de vendas e sugerir reposições.
  #
  # @!attribute [rw] produto_id
  #   @return [Integer] ID do produto associado
  # @!attribute [rw] lote_id
  #   @return [Integer, nil] ID do lote associado (opcional)
  # @!attribute [rw] quantidade_atual
  #   @return [Integer] Quantidade atual em estoque
  # @!attribute [rw] quantidade_minima
  #   @return [Integer, nil] Quantidade mínima recomendada
  # @!attribute [rw] quantidade_ideal
  #   @return [Integer, nil] Quantidade ideal para manter
  # @!attribute [rw] media_vendas_diarias
  #   @return [Decimal, nil] Média de vendas diárias calculada
  # @!attribute [rw] ultima_atualizacao
  #   @return [DateTime, nil] Data e hora da última atualização
  # @!attribute [rw] created_at
  #   @return [DateTime] Data e hora de criação do registro
  # @!attribute [rw] updated_at
  #   @return [DateTime] Data e hora da última atualização do registro
  class Estoque < ApplicationRecord

  include Discard::Model if defined?(Discard::Model)

  after_commit :avisar_frontends, on: [:create, :update]

  private

  def avisar_frontends
    ActionCable.server.broadcast("estoques_channel", { acao: "atualizado", id: self.id })
  end

  public
    # @!group Associações

    # Associação obrigatória com produto
    belongs_to :produto

    # Associação opcional com lote
    belongs_to :lote, optional: true

    # Associação com ajustes de estoque
    has_many :ajuste_estoques

    # @!endgroup

    # @!group Validações

    # Valida que a quantidade atual seja um inteiro não-negativo
    validates :quantidade_atual,
              numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "Quantidade atual deve ser um número inteiro maior ou igual a zero" }

    # Valida que a quantidade mínima seja um inteiro não-negativo
    validates :quantidade_minima,
              numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "Quantidade mínima deve ser um número inteiro maior ou igual a zero" },
              allow_nil: true

    # Valida que a quantidade ideal seja um inteiro não-negativo
    validates :quantidade_ideal,
              numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "Quantidade ideal deve ser um número inteiro maior ou igual a zero" },
              allow_nil: true

    # @!endgroup

    # @!group Scopes

    # Filtra estoques com quantidade atual abaixo ou igual à mínima
    # @return [ActiveRecord::Relation] Estoques em nível baixo
    scope :baixo, -> { where("quantidade_atual <= quantidade_minima") }

    # Filtra estoques com quantidade atual abaixo da ideal
    # @return [ActiveRecord::Relation] Estoques abaixo do ideal
    scope :abaixo_ideal, -> { where("quantidade_atual < quantidade_ideal") }

    # @!endgroup

    # Calcula a média de vendas diárias baseada nas vendas dos últimos 30 dias.
    #
    # @return [void] Atualiza o atributo media_vendas_diarias
    # @note Usa vendas do lote associado; assume período de 30 dias
    def calcular_media_vendas_diarias
      vendas_totais = ItemVenda.joins(:venda).where(lote_id: lote_id, vendas: { created_at: 30.days.ago..Time.current }).sum(:quantidade)
      dias = 30
      update(media_vendas_diarias: vendas_totais.to_f / dias)
    end

    # Sugere a quantidade necessária para reposição até o nível ideal.
    #
    # @return [Integer] Quantidade sugerida (mínimo 0)
    def quantidade_sugerida_reposicao
      [ quantidade_ideal - quantidade_atual, 0 ].max
    end

    # Ajusta a quantidade atual e atualiza a última atualização.
    #
    # @param delta [Integer] Valor a adicionar/subtrair da quantidade atual
    # @return [void] Atualiza quantidade_atual e ultima_atualizacao; recalcula média se delta negativo
    # @note Recalcula média de vendas após vendas (delta < 0)
    def ajustar_quantidade(delta)
      update(quantidade_atual: quantidade_atual + delta, ultima_atualizacao: Time.current)
      calcular_media_vendas_diarias if delta < 0  # Recalcula após venda
    end
  endend
