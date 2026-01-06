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
class Categoria < ApplicationRecord
  # Associações
  # Categoria pai (opcional, para hierarquia)
  belongs_to :categoria_pai, class_name: "Categoria", optional: true
  # Subcategorias (dependentes, destruídas se a categoria pai for destruída)
  has_many :subcategorias, class_name: "Categoria", foreign_key: :categoria_pai_id, dependent: :destroy
  # Usuário que criou a categoria (opcional)
  belongs_to :criado_por, class_name: "Usuario", optional: true

  # Enum para status da categoria com prefixo
  enum :status_da_categoria, {
    disponivel: 0,
    inativo: 1,
    arquivado: 2
  }, prefix: :categoria

  # Callbacks
  # Define a ordem automaticamente na criação se não fornecida
  before_validation :set_ordem, on: :create
  # Define o status padrão como disponível na criação
  before_validation :set_default_status, on: :create

  # Validações
  # Nome: presença, unicidade e comprimento máximo
  validates :nome,
            presence: { message: "não pode ficar em branco" },
            uniqueness: { message: "já está em uso" },
            length: { maximum: 255, message: "deve ter no máximo 255 caracteres" }
  # Ordem: presença e numérica inteira positiva
  validates :ordem, presence: true, numericality: { only_integer: true, greater_than: 0 }
  # Status: deve estar na lista de valores permitidos
  validates :status_da_categoria, inclusion: { in: status_da_categoria.keys }
  # Excluído: deve ser booleano
  validates :excluido, inclusion: { in: [ true, false ] }
  # Taxa de lucro: numérica inteira não negativa (opcional)
  validates :taxa_de_lucro,
            numericality: { greater_than_or_equal_to: 0, only_integer: true },
            allow_nil: true
  # Imposto: numérico não negativo
  validates :imposto, numericality: { greater_than_or_equal_to: 0 }
  # Validação customizada: categoria não pode ser pai de si mesma
  validate :categoria_nao_pode_ser_pai_de_si_mesma

  # Escopos
  # Retorna apenas categorias ativas (disponíveis)
  scope :ativas, -> { where(status_da_categoria: :disponivel) }
  # Retorna apenas categorias não excluídas
  scope :nao_excluidas, -> { where(excluido: false) }
  # Ordena por ordem ascendente
  scope :por_ordem, -> { order(:ordem) }
  # Retorna apenas categorias raiz (sem pai)
  scope :raiz, -> { where(categoria_pai_id: nil) }

  # Métodos públicos

  # Decodifica a imagem em base64 para bytes.
  #
  # @return [String, nil] a imagem decodificada ou nil se inválida
  def imagem_decodificada
    return nil unless imagem.present?

    unless imagem =~ %r{\A[A-Za-z0-9+\/=]+\z} && (imagem.length % 4).zero?
      return nil
    end

    Base64.decode64(imagem)
  rescue ArgumentError
    nil
  end

  # Verifica se a categoria é raiz (não tem pai).
  #
  # @return [Boolean] true se for categoria raiz
  def raiz?
    categoria_pai.nil?
  end

  # Verifica se a categoria é folha (não tem subcategorias).
  #
  # @return [Boolean] true se for categoria folha
  def folha?
    subcategorias.empty?
  end

  # Calcula o preço total com lucro e imposto baseado no preço base.
  #
  # @param preco_base [Numeric] o preço base do produto
  # @return [BigDecimal, nil] o preço total calculado ou nil se preco_base for nil
  def lucro_total(preco_base)
    return nil if preco_base.nil?

    base = preco_base.to_d
    margem = (taxa_de_lucro || 0).to_d / 100
    base * (1 + margem) + (imposto || 0).to_d
  end

  private

  # Define a ordem da categoria na criação.
  #
  # @return [void]
  # @private
  def set_ordem
    self.ordem = (Categoria.maximum(:ordem) || 0) + 1 if ordem.blank?
  end

  # Define o status padrão como disponível na criação.
  #
  # @return [void]
  # @private
  def set_default_status
    self.status_da_categoria ||= :disponivel
  end

  # Validação customizada para impedir categoria pai de si mesma.
  #
  # @return [void]
  # @private
  def categoria_nao_pode_ser_pai_de_si_mesma
    if categoria_pai_id.present? && categoria_pai_id == id
      errors.add(:categoria_pai, "não pode ser pai de si mesma")
    end
  end
end
