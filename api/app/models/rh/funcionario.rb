# frozen_string_literal: true

# Este model gerencia os funcionários da empresa.
class Rh::Funcionario < ApplicationRecord
  include Discard::Model if defined?(Discard::Model)

  self.table_name = "funcionarios"

  after_commit :avisar_frontends, on: [ :create, :update ]

private

def avisar_frontends
  ActionCable.server.broadcast("funcionarios_channel", { acao: "atualizado", id: self.id })
end

public
include Discard::Model

  # Evita que o Rails tente buscar a tabela "rh_funcionarios"
  self.table_name = "funcionarios"

  # Relações explicitas usando class_name completo
  belongs_to :usuario, class_name: "Admin::Usuario"
  belongs_to :cargo, class_name: "Rh::Cargo"
  belongs_to :tipos_contrato, class_name: "Admin::TiposContrato", optional: true

  has_many :registro_pausas, class_name: "Rh::RegistroPausa", dependent: :destroy

  validates :cpf, presence: true, uniqueness: true

  # Delega os campos de identificação para o model Admin::Usuario
  delegate :email, :primeiro_nome, :ultimo_nome, :nome_usuario, to: :usuario, allow_nil: true
end
