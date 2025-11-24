class Cargo < ApplicationRecord
  belongs_to :criado_por, class_name: 'Usuario', optional: true

  validates :nome, presence: true, uniqueness: true
end
