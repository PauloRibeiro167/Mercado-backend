class Fornecedor < ApplicationRecord
  belongs_to :user
  belongs_to :responsavel, class_name: 'User'
end
