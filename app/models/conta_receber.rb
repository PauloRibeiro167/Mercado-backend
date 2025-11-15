class ContaReceber < ApplicationRecord
  belongs_to :venda
  belongs_to :cliente
end
