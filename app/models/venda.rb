class Venda < ApplicationRecord
  belongs_to :metodo_pagamento
  has_many :item_vendas, dependent: :destroy
  has_many :lotes, through: :item_vendas
end
