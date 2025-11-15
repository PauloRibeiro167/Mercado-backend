class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Relacionamento 1:1 com Funcionario
  has_one :funcionario, inverse_of: :user, dependent: :nullify

  # A mágica do N:N com Perfis
  has_many :usuario_perfis, dependent: :destroy
  has_many :perfis, through: :usuario_perfis
end
