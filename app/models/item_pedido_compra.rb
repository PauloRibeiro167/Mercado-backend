class ItemPedidoCompra < ApplicationRecord
  belongs_to :pedido_compra
  belongs_to :produto
end
