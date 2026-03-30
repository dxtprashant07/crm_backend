module RequestSpecHelper
  # Returns valid JWT auth headers for a given user
  def auth_headers(user)
    token = JsonWebToken.encode(user_id: user.id)
    { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" }
  end

  # Parse JSON response body
  def json
    JSON.parse(response.body, symbolize_names: true)
  end
end
