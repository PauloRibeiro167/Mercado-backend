require 'base64'

module Estoque
  module Base64Decodable
    # Decodes a Base64-encoded string stored in a given attribute.
    # If the value is nil or not a data URL, returns the value as-is.
    def decodificar_base64(attr)
      value = self.send(attr)
      return nil if value.nil?
      return value unless value.is_a?(String)

      # Handle common data URL format: "data:<type>;base64,<base64data>"
      if value.include?("base64,")
        _prefix, base64data = value.split(",", 2)
        return Base64.decode64(base64data)
      end
      value
    end
  end
end
