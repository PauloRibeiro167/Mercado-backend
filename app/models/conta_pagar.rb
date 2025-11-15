class ContaPagar < ApplicationRecord
  belongs_to :fornecedor
  belongs_to :pedido_compra
end
