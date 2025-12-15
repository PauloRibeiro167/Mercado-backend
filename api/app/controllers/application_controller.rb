class ApplicationController < ActionController::API
  include Pundit::Authorization
  require "jwt"

  before_action :authenticate_user!

  def current_user
    @current_user ||= begin
      if session[:user_id]
        Usuario.find(session[:user_id])
      elsif request.headers["Authorization"].present?
        token = request.headers["Authorization"].split(" ").last
        decoded = decode_token(token)
        Usuario.find(decoded["user_id"]) if decoded
      end
    end
  end

  private

  def authenticate_user!
    unless current_user
      render json: { success: false, error: "Token inválido ou ausente" }, status: :unauthorized
    end
  end

  def decode_token(token)
    JWT.decode(token, Rails.application.secret_key_base, true, algorithm: "HS256")[0]
  rescue JWT::DecodeError
    nil
  end

  # Torna route_not_found uma action pública para ser usada como rota coringa
  public

  def route_not_found
    render json: { error: "Rota não encontrada ou método não permitido." }, status: :not_found
  end

  def method_not_allowed
    render json: { error: "Método HTTP não permitido para este endpoint." }, status: :method_not_allowed
  end

  rescue_from ActionDispatch::Http::Parameters::ParseError, JSON::ParserError do |e|
    Rails.logger.warn("ParseError: #{e.message}")
    render json: { success: false, message: "Requisição inválida" }, status: :bad_request
  end

  rescue_from ActionController::ParameterMissing do |e|
    Rails.logger.warn("ParameterMissing: #{e.param}")
    render json: { success: false, message: "Parâmetros obrigatórios ausentes" }, status: :bad_request
  end

  rescue_from ActiveRecord::StatementInvalid do |e|
    Rails.logger.error("StatementInvalid: #{e.message}")
    render json: { success: false, message: "Erro ao processar requisição" }, status: :unprocessable_entity
  end

  rescue_from ActionController::RoutingError, with: :route_not_found
  rescue_from ActionController::UnknownHttpMethod, with: :method_not_allowed

  def route_not_found
    render json: { error: "Rota não encontrada ou método não permitido." }, status: :not_found
  end

  def method_not_allowed
    render json: { error: "Método HTTP não permitido para este endpoint." }, status: :method_not_allowed
  end
end
