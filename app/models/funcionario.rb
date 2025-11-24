class Funcionario < ApplicationRecord
  belongs_to :usuario, optional: false
  belongs_to :cargo, optional: false
end
