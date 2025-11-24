class Fornecedor < ApplicationRecord
  belongs_to :usuario
  belongs_to :responsavel, class_name: 'Usuario'
end
