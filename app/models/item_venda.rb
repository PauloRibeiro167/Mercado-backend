class ItemVenda < ApplicationRecord
  belongs_to :lote
  belongs_to :venda
end
