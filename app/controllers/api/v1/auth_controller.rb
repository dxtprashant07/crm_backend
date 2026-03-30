module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_request!, only: %i[signup login]

      # POST /api/v1/auth/signup
      def signup
        user = User.create!(signup_params)
        token = JsonWebToken.encode(user_id: user.id)
        json_response({ message: "Account created successfully", token: token, user: serialize_user(user) }, :created)
      end

      # POST /api/v1/auth/login
      def login
        user = User.find_by!(email: params[:email].to_s.downcase)
        if user.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          json_response({ message: "Logged in successfully", token: token, user: serialize_user(user) })
        else
          json_response({ error: "Invalid email or password" }, :unauthorized)
        end
      end

      # GET /api/v1/auth/me
      def me
        json_response({ user: serialize_user(current_user) })
      end

      private

      def signup_params
        params.permit(:name, :email, :password, :password_confirmation, :role)
      end

      def serialize_user(user)
        { id: user.id, name: user.name, email: user.email, role: user.role, created_at: user.created_at }
      end
    end
  end
end
