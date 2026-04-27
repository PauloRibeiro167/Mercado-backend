module Hierarquia
  extend ActiveSupport::Concern

  included do
    belongs_to :categoria_pai, class_name: self.name, optional: true
    has_many :subcategorias, class_name: self.name, foreign_key: :categoria_pai_id, dependent: :destroy

    validate :nao_pode_ser_pai_de_si_mesma

    scope :raiz, -> { where(categoria_pai_id: nil) }
  end

  def raiz?
    categoria_pai.nil?
  end

  def folha?
    subcategorias.empty?
  end

  private

  def nao_pode_ser_pai_de_si_mesma
    if categoria_pai_id.present? && categoria_pai_id == id
      errors.add(:categoria_pai, "não pode ser pai de si mesma")
    end
  end
end
