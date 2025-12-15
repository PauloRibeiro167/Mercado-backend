class Categoria < ApplicationRecord
  # Associações
  belongs_to :categoria_pai, class_name: "Categoria", optional: true
  has_many :subcategorias, class_name: "Categoria", foreign_key: :categoria_pai_id, dependent: :destroy
  belongs_to :criado_por, class_name: "Usuario", optional: true

  enum :status_da_categoria, {
    disponivel: 0,
    inativo: 1,
    arquivado: 2
  }, prefix: :categoria

  # Callbacks
  before_validation :set_ordem, on: :create
  before_validation :set_default_status, on: :create

  # Validações
  validates :nome,
            presence: { message: "não pode ficar em branco" },
            uniqueness: { message: "já está em uso" },
            length: { maximum: 255, message: "deve ter no máximo 255 caracteres" }
  validates :ordem, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :status_da_categoria, inclusion: { in: status_da_categoria.keys }
  validates :excluido, inclusion: { in: [ true, false ] }
  validates :taxa_de_lucro,
            numericality: { greater_than_or_equal_to: 0, only_integer: true },
            allow_nil: true
  validates :imposto, numericality: { greater_than_or_equal_to: 0 }
  validate :categoria_nao_pode_ser_pai_de_si_mesma

  # Escopos
  scope :ativas, -> { where(status_da_categoria: :disponivel) }
  scope :nao_excluidas, -> { where(excluido: false) }
  scope :por_ordem, -> { order(:ordem) }
  scope :raiz, -> { where(categoria_pai_id: nil) }

  # Métodos públicos
  def imagem_decodificada
    return nil unless imagem.present?

    unless imagem =~ %r{\A[A-Za-z0-9+\/=]+\z} && (imagem.length % 4).zero?
      return nil
    end

    Base64.decode64(imagem)
  rescue ArgumentError
    nil
  end

  def raiz?
    categoria_pai.nil?
  end

  def folha?
    subcategorias.empty?
  end

  def lucro_total(preco_base)
    return nil if preco_base.nil?

    base = preco_base.to_d
    margem = (taxa_de_lucro || 0).to_d / 100
    base * (1 + margem) + (imposto || 0).to_d
  end

  private

  def set_ordem
    self.ordem = (Categoria.maximum(:ordem) || 0) + 1 if ordem.blank?
  end

  def set_default_status
    self.status_da_categoria ||= :disponivel
  end

  def categoria_nao_pode_ser_pai_de_si_mesma
    if categoria_pai_id.present? && categoria_pai_id == id
      errors.add(:categoria_pai, "não pode ser pai de si mesma")
    end
  end
end
