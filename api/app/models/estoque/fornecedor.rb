module Estoque
  class Fornecedor < ApplicationRecord
  include Discard::Model

    belongs_to :usuario, class_name: "Admin::Usuario"
    belongs_to :responsavel, class_name: "Admin::Usuario"

    has_many :pedido_compras
    has_many :produto_fornecedors
    has_many :produtos, through: :produto_fornecedors

    # Validações
    validates :nome,
              presence: { message: "Nome não pode ficar em branco" },
              uniqueness: { message: "Nome já está em uso" }

    validates :cnpj,
              presence: { message: "CNPJ não pode ficar em branco" },
              uniqueness: { message: "CNPJ já está em uso" }

    validates :contato_nome,
              presence: { message: "Nome do contato não pode ficar em branco" }

    validates :telefone,
              presence: { message: "Telefone não pode ficar em branco" }

    validates :email,
              format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email deve ter um formato válido" },
              uniqueness: { case_sensitive: false, message: "Email já está em uso" },
              allow_blank: true

    # Método para verificar se fornecedor está ativo
    def ativo?
      ativo
    end

    # Método para desativar fornecedor
    def desativar
      update(ativo: false)
    end

    # Método para ativar fornecedor
    def ativar
      update(ativo: true)
    end
  end
end
