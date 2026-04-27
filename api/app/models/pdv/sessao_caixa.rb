module Pdv
  class SessaoCaixa < ApplicationRecord
    # Associações
    belongs_to :usuario, class_name: 'Admin::Usuario'

    belongs_to :caixa
    belongs_to :usuario_abertura, class_name: "Admin::Usuario"
    belongs_to :usuario_fechamento, class_name: "Admin::Usuario", optional: true
    belongs_to :gerente_supervisor, class_name: "Admin::Usuario", optional: true
    has_many :vendas
    has_many :movimentacao_caixas, as: :origem

    # Enum para status
    enum :status, { aberta: "aberta", fechada: "fechada", cancelada: "cancelada" }

    # Validações
    validates :valor_inicial,
              numericality: { greater_than_or_equal_to: 0, message: "Valor inicial deve ser maior ou igual a zero" }

    validates :abertura,
              presence: { message: "Abertura não pode ficar em branco" }

    validates :fechamento,
              presence: { message: "Fechamento não pode ficar em branco" },
              if: :fechada?

    validates :valor_final,
              numericality: { greater_than_or_equal_to: 0, message: "Valor final deve ser maior ou igual a zero" },
              allow_nil: true

    validates :saldo_esperado,
              numericality: { greater_than_or_equal_to: 0, message: "Saldo esperado deve ser maior ou igual a zero" },
              allow_nil: true

    validates :diferenca,
              numericality: { message: "Diferença deve ser um número" },
              allow_nil: true

    # Validações customizadas para regras de negócio
    validate :mesmo_usuario_abre_fecha, if: :fechada?
    validate :supervisao_gerente_no_fechamento, if: :fechada?

    # Callbacks
    before_save :calcular_saldo_esperado, if: :fechada?
    before_save :forcar_fechamento_se_ultrapassado, if: :aberta?

    # Métodos de classe
    def self.abrir_sessao(caixa, usuario, valor_inicial)
      create!(
        caixa: caixa,
        usuario_abertura: usuario,
        abertura: Time.current,
        valor_inicial: valor_inicial,
        status: :aberta
      )
    end

    def fechar_sessao(usuario, gerente, valor_final_real)
      update(
        status: :fechada,
        fechamento: Time.current,
        usuario_fechamento: usuario,
        gerente_supervisor: gerente,
        valor_final: valor_final_real
      )
    end

    def calcular_saldo_esperado
      entradas = movimentacao_caixas.where(tipo: "entrada").sum(:valor)
      saidas = movimentacao_caixas.where(tipo: "saida").sum(:valor)
      suprimentos = movimentacao_caixas.where(tipo: "suprimento").sum(:valor)
      sangrias = movimentacao_caixas.where(tipo: "sangria").sum(:valor)
      self.saldo_esperado = valor_inicial + entradas + suprimentos - saidas - sangrias
      self.diferenca = valor_final - saldo_esperado if valor_final.present?
    end

    def forcar_fechamento_se_ultrapassado
      horario_fechamento = HorarioFuncionamento.horario_fechamento_hoje
      if horario_fechamento && Time.current > horario_fechamento + 1.hour
        self.status = :fechada
        self.fechamento = Time.current
        self.usuario_fechamento = usuario_abertura
        self.gerente_supervisor = Usuario.where(perfil: "gerente").first || usuario_abertura
        self.valor_final ||= valor_inicial
        self.observacoes_fechamento = "Fechamento automático devido a ultrapassar horário da loja"
      end
    end

    # Validação para sessão única aberta por usuário
    validate :unica_sessao_aberta_por_usuario, on: :create

    private

    def unica_sessao_aberta_por_usuario
      if usuario_abertura_id.present? && SessaoCaixa.where(usuario_abertura_id: usuario_abertura_id, status: :aberta).exists?
        errors.add(:base, "Já existe uma sessão aberta para este usuário.")
      end
    end

    def mesmo_usuario_abre_fecha
      if usuario_abertura != usuario_fechamento
        errors.add(:usuario_fechamento, "deve ser o mesmo usuário que abriu a sessão")
      end
    end

    def supervisao_gerente_no_fechamento
      if gerente_supervisor.blank?
        errors.add(:gerente_supervisor, "deve ser preenchido para supervisionar o fechamento")
      end
    end
  end
end
