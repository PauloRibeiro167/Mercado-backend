class Categoria < ApplicationRecord
  # Para decodificar base64 (exemplo)
  def imagem_decodificada
    Base64.decode64(imagem) if imagem.present?
  end
end
