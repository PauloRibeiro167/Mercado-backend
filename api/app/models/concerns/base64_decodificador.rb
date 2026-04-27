module Base64Decodificador
  extend ActiveSupport::Concern

  def decodificar_base64(campo)
    valor = self.send(campo)
    return nil unless valor.present?

    unless valor =~ %r{\A[A-Za-z0-9+\/=]+\z} && (valor.length % 4).zero?
      return nil
    end

    Base64.decode64(valor)
  rescue ArgumentError
    nil
  end
end
