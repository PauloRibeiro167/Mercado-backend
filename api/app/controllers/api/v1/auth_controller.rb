require "jwt"

class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: :login

  def login
    usuario = Usuario.find_by(email: params[:email])
    if usuario && usuario.authenticate_senha(params[:password])
      access_token = encode_token({ user_id: usuario.id }, 30.minutes.from_now)
      refresh_token = encode_token({ user_id: usuario.id }, 14.days.from_now)
      render json: { access_token: access_token, refresh_token: refresh_token, user: usuario }, status: :ok
    else
      render json: { error: "Credenciais inválidas" }, status: :unauthorized
    end
  end

  def refresh
    refresh_token = params[:refresh_token]
    begin
      decoded = JWT.decode(refresh_token, Rails.application.secret_key_base, true, { algorithm: "HS256" })
      user_id = decoded[0]["user_id"]
      # (Opcional: checar se refresh_token está em uma allowlist)
      access_token = encode_token({ user_id: user_id }, 30.minutes.from_now)
      render json: { access_token: access_token }
    rescue JWT::ExpiredSignature, JWT::DecodeError
      render json: { error: "Refresh token inválido ou expirado" }, status: :unauthorized
    end
  end

  private

  def encode_token(payload, exp = nil)
    payload[:exp] = exp.to_i if exp
    JWT.encode(payload, Rails.application.secret_key_base, "HS256")
  end
end
