# frozen_string_literal: true

# Modelo que representa uma categoria de produtos no sistema.
#
# Esta classe funciona como um tipo ou classe de produtos, permitindo classificar e organizar
# produtos em grupos hierárquicos. Por exemplo, uma categoria "Laticínios" pode conter
# subcategorias como "Leite", "Queijo", "Iogurte", facilitando a busca, separação e
# gerenciamento de produtos por tipo.
#
# Cada produto pertence a uma categoria, e categorias podem ter subcategorias para
# criar uma estrutura em árvore, permitindo classificações detalhadas.
#
# @attr nome [String] o nome único da categoria (máximo 255 caracteres)
# @attr descricao [String] a descrição da categoria
# @attr ordem [Integer] a ordem de exibição da categoria
# @attr status_da_categoria [String] o status da categoria ('disponivel', 'inativo', 'arquivado')
# @attr excluido [Boolean] indica se a categoria foi excluída logicamente
# @attr taxa_de_lucro [Integer] a taxa de lucro em porcentagem
# @attr imposto [Decimal] o valor do imposto fixo
# @attr imagem [String] a imagem da categoria em base64
# @attr categoria_pai [Categoria] a categoria pai (opcional, para hierarquia)
# @attr criado_por [Usuario] o usuário que criou a categoria
class Estoque::Categoria < ApplicationRecord
  include Discard::Model if defined?(Discard::Model)
  include Estoque::Base64Decodable
  include Hierarquia

  self.table_name = "categorias"

  belongs_to :criado_por, class_name: "Admin::Usuario", optional: true

  enum :status_da_categoria, {
    disponivel: 0,
    inativo: 1,
    arquivado: 2
  }, prefix: :categoria

  scope :ativas, -> { where(status_da_categoria: :disponivel) }
  scope :nao_excluidas, -> { where(excluido: false) }
  scope :por_ordem, -> { order(:ordem) }

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

  before_validation :set_ordem, on: :create
  before_validation :set_default_status, on: :create

  after_commit :avisar_frontends, on: %i[create update]

  def imagem_decodificada
    decodificar_base64(:imagem)
  end

  private

  def avisar_frontends
    ActionCable.server.broadcast("categorias_channel", { acao: "atualizado", id: id })
  end

  def set_ordem
    self.ordem = (self.class.maximum(:ordem) || 0) + 1 if ordem.blank?
  end

  def set_default_status
    self.status_da_categoria ||= :disponivel
  end
end
