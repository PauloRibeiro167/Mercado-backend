require "jwt"

# Controller responsável pela autenticação de usuários na API.
#
# Este controller gerencia o login de usuários, geração de tokens de acesso, assim como o refresh, o processo de renovação de tokens de acesso usa JWT.
#
# @author [Paulo Ribeiro]
# @since [01-alfa-2026]
class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: :login

  # Realiza o login do usuário e gera tokens de acesso e refresh.
  #
  # Verifica as credenciais do usuário (email e senha) e, se válidas,
  # gera um token de acesso (válido por 30 minutos) e um token de refresh (válido por 14 dias).
  #
  # @return [JSON] um objeto JSON contendo access_token, refresh_token e dados do usuário se login bem-sucedido
  # @return [JSON] um objeto JSON com erro se credenciais inválidas
  # @example
  #   POST /api/v1/auth/login
  #   {
  #     "email": "usuario@example.com",
  #     "password": "senha123"
  #   }
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

  # Renova o token de acesso utilizando um token de refresh válido.
  #
  # Decodifica o token de refresh fornecido e gera um novo token de acesso
  # se o refresh token for válido e não expirado.
  #
  # @return [JSON] um objeto JSON contendo o novo access_token se bem-sucedido
  # @return [JSON] um objeto JSON com erro se o refresh token for inválido ou expirado
  # @raise [JWT::ExpiredSignature] se o token de refresh estiver expirado
  # @raise [JWT::DecodeError] se o token de refresh for inválido
  # @example
  #   POST /api/v1/auth/refresh
  #   {
  #     "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
  #   }
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

  # Codifica um payload em um token JWT.
  #
  # Adiciona uma expiração opcional ao payload e codifica usando HS256.
  #
  # @param payload [Hash] o payload a ser codificado no token
  # @param exp [Time, nil] a data/hora de expiração do token (opcional)
  # @return [String] o token JWT codificado
  # @private
  def encode_token(payload, exp = nil)
    payload[:exp] = exp.to_i if exp
    JWT.encode(payload, Rails.application.secret_key_base, "HS256")
  end
end
