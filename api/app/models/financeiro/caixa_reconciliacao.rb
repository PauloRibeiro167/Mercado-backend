module Financeiro
  # frozen_string_literal: true

  # Model para auditorias de reconciliação sobre um caixa específico, permitindo rastrear divergências
  # entre o saldo registrado e o valor físico encontrado.
  #
  # @see Caixa
  # @see SessaoCaixa
  #
  # @!attribute [rw] caixa
  #   Caixa auditado no processo.
  #   @return [Caixa]
  # @!attribute [rw] usuario_responsavel
  #   Usuário que executou a reconciliação e aprovou o ajuste.
  #   @return [Usuario]
  # @!attribute [rw] sessao_caixa
  #   Sessão do caixa na qual a divergência foi identificada.
  #   @return [SessaoCaixa]
  # @!method usuario_operador
  #   Usuário que operava o caixa na sessão informada (derivado de {SessaoCaixa#usuario}).
  #   @return [Usuario, nil]
  # @!attribute [rw] saldo_registrado
  #   Valor total calculado pelo sistema no momento da conferência.
  #   @return [BigDecimal]
  # @!attribute [rw] saldo_fisico
  #   Valor contado fisicamente no caixa.
  #   @return [BigDecimal]
  # @!attribute [rw] diferenca
  #   Diferença em reais entre o saldo físico e o saldo registrado.
  #   @return [BigDecimal]
  # @!attribute [rw] motivo
  #   Motivo categorizado que levou à reconciliação (vide {.motivos}).
  #   @return [String]
  # @!attribute [rw] observacoes
  #   Observações adicionais fornecidas pelo auditor.
  #   @return [String, nil]
  # @!attribute [rw] realizada_em
  #   Data e hora em que a reconciliação foi efetivada.
  #   @return [Time]
  # @!attribute [rw] status
  #   Estado do processo (vide {statuses}).
  #   @return [String]
  # @!method self.statuses
  #   Mapa de estados válidos para reconciliações.
  #   @return [Hash{String=>String}]
  # @!method self.motivos
  #   Mapa de motivos categorizados disponíveis.
  #   @return [Hash{String=>String}]
  class CaixaReconciliacao < ApplicationRecord

  include Discard::Model if defined?(Discard::Model)

  after_commit :avisar_frontends, on: [:create, :update]

  private

  def avisar_frontends
    ActionCable.server.broadcast("caixa_reconciliacaos_channel", { acao: "atualizado", id: self.id })
  end

  public
    self.table_name = "caixa_reconciliacoes"

    # Enumera estados e motivos para facilitar filtros de auditoria.
    enum :status, pendente: "pendente", aprovado: "aprovado", rejeitado: "rejeitado"
    enum :motivo, divergencia_contagem: "divergencia_contagem", deposito_nao_registrado: "deposito_nao_registrado", sangria_nao_registrada: "sangria_nao_registrada", suprimento_nao_registrado: "suprimento_nao_registrado", ajuste_manual: "ajuste_manual", outros: "outros"

    belongs_to :caixa, class_name: 'Pdv::Caixa'
    belongs_to :usuario_responsavel, class_name: "Admin::Usuario"
    belongs_to :sessao_caixa

    delegate :usuario, to: :sessao_caixa, prefix: true, allow_nil: true

    validates :saldo_registrado,
              numericality: { greater_than_or_equal_to: 0, message: "Saldo registrado deve ser maior ou igual a zero" }

    validates :saldo_fisico,
              numericality: { greater_than_or_equal_to: 0, message: "Saldo físico deve ser maior ou igual a zero" }

    validates :diferenca,
              numericality: true

    validates :motivo,
              presence: { message: "Motivo não pode ficar em branco" }

    validates :observacoes,
              length: { maximum: 2000, message: "Observações devem ter no máximo 2000 caracteres" },
              allow_blank: true

    validates :realizada_em,
              presence: { message: "Data de realização não pode ficar em branco" }

    validates :usuario_responsavel,
              presence: { message: "Usuário responsável é obrigatório" }

    validates :caixa,
              presence: { message: "Caixa é obrigatório" }

    validates :sessao_caixa,
              presence: { message: "Sessão do caixa é obrigatória" }

    validate :sessao_compativel_com_caixa

    before_validation :preencher_diferenca

    # Calcula a diferença com base nos saldos quando não informada.
    #
    # @return [void]
    def preencher_diferenca
      return if diferenca.present?
      return if saldo_registrado.blank? || saldo_fisico.blank?

      self.diferenca = saldo_fisico - saldo_registrado
    end

    # Garante que a sessão informada pertença ao mesmo caixa auditado.
    #
    # @return [void]
    def sessao_compativel_com_caixa
      return if sessao_caixa.blank? || caixa.blank?
      return if sessao_caixa.caixa_id == caixa_id

      errors.add(:sessao_caixa, "deve pertencer ao mesmo caixa informado")
    end

    # Retorna o usuário operador derivado da sessão associada.
    #
    # @return [Usuario, nil]
    def usuario_operador
      sessao_caixa_usuario
    end
  end
end
