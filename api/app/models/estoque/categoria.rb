class Estoque::Categoria < ApplicationRecord
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
self.table_name = "categorias"

  # Use proper module namespaces to resolve Base64 decoding and hierarchy helpers
  include Estoque::Base64Decodable
  include Hierarquia

# Associações
# Usuário que criou a categoria (opcional)
belongs_to :criado_por, class_name: "Admin::Usuario", optional: true

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

# Escopos
# Retorna apenas categorias ativas (disponíveis)
scope :ativas, -> { where(status_da_categoria: :disponivel) }
# Retorna apenas categorias não excluídas
scope :nao_excluidas, -> { where(excluido: false) }
# Ordena por ordem ascendente
scope :por_ordem, -> { order(:ordem) }

# Métodos públicos

  # Decodifica a imagem em base64 para bytes.
  #
  # @return [String, nil] a imagem decodificada ou nil se inválida
  def imagem_decodificada
    decodificar_base64(:imagem)
  end




  
  after_commit :avisar_frontends, on: [:create, :update]

  private

  def avisar_frontends
    ActionCable.server.broadcast("#{ch}", { acao: "atualizado", id: self.id })
  end

  public
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

end
