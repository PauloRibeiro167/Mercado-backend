class MovimentacaoCaixa < ApplicationRecord
  belongs_to :conta_pagar
  belongs_to :conta_receber
end
