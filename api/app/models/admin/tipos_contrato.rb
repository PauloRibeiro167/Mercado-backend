class Admin::TiposContrato < ApplicationRecord

  include Discard::Model if defined?(Discard::Model)

  after_commit :avisar_frontends, on: [:create, :update]

  private

  def avisar_frontends
    ActionCable.server.broadcast("tipos_contratos_channel", { acao: "atualizado", id: self.id })
  end

  public
  self.table_name = "tipos_contratos"

  has_many :funcionarios

  validates :nome,
            presence: { message: "Nome não pode ficar em branco" },
            uniqueness: { message: "Nome já está em uso" }

  validates :ativo,
            inclusion: { in: [ true, false ], message: "Ativo deve ser verdadeiro ou falso" },
            allow_nil: true
end
