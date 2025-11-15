class AjusteEstoque < ApplicationRecord
  belongs_to :lote
  belongs_to :usuario
end
