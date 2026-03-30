module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken        < StandardError; end
  class InvalidToken        < StandardError; end
  class ExpiredToken        < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { error: "Not Found", message: e.message }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { error: "Validation Failed", message: e.message }, status: :unprocessable_entity
    end

    rescue_from ActionController::ParameterMissing do |e|
      render json: { error: "Missing Parameter", message: e.message }, status: :bad_request
    end

    rescue_from ExceptionHandler::AuthenticationError do |e|
      render json: { error: "Unauthorized", message: e.message }, status: :unauthorized
    end

    rescue_from ExceptionHandler::MissingToken do |e|
      render json: { error: "Missing Token", message: e.message }, status: :unauthorized
    end

    rescue_from ExceptionHandler::InvalidToken do |e|
      render json: { error: "Invalid Token", message: e.message }, status: :unauthorized
    end

    rescue_from ExceptionHandler::ExpiredToken do |e|
      render json: { error: "Expired Token", message: e.message }, status: :unauthorized
    end
  end
end
