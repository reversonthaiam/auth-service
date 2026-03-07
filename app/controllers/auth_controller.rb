class AuthController < ApplicationController
  def register
    user = User.new(user_params)

    if user.save
      token = generate_token(user)
      render json: { message: "Usuario criado com sucesso", token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = generate_token(user)
      render json: { message: "Login realizado com sucesso", token: token }, status: :ok
    else
      render json: { error: "Email ou senha invalidos" }, status: :unauthorized
    end
  end

  def validate
    token = request.headers["Authorization"]&.split(" ")&.last

    if token.nil?
      render json: { error: "Token nao informado" }, status: :unauthorized
      return
    end

    payload = decode_token(token)

    if payload
      user = User.find_by(id: payload["user_id"])
      if user
        render json: { valid: true, user: { id: user.id, email: user.email } }, status: :ok
      else
        render json: { valid: false, error: "Usuario nao encontrado" }, status: :unauthorized
      end
    else
      render json: { valid: false, error: "Token invalido ou expirado" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def generate_token(user)
    payload = {
      user_id: user.id,
      email: user.email,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, jwt_secret, "HS256")
  end

  def decode_token(token)
    JWT.decode(token, jwt_secret, true, { algorithm: "HS256" }).first
  rescue JWT::DecodeError
    nil
  end

  def jwt_secret
    ENV.fetch("JWT_SECRET", "desenvolvimento_secret")
  end
end