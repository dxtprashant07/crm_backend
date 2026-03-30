class ApplicationController < ActionController::API
  include ExceptionHandler

  before_action :authenticate_request!

  private

  def authenticate_request!
    @current_user = decode_token
  end

  def current_user
    @current_user
  end

  def decode_token
    header = request.headers["Authorization"]
    raise ExceptionHandler::MissingToken, "Authorization header missing" unless header

    token = header.split(" ").last
    decoded = JsonWebToken.decode(token)
    User.find(decoded[:user_id])
  rescue ActiveRecord::RecordNotFound
    raise ExceptionHandler::InvalidToken, "User not found"
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      total_pages:  collection.total_pages,
      total_count:  collection.total_count,
      per_page:     collection.limit_value
    }
  end
end
