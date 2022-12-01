# frozen_string_literal: true

# Controller to handle authorization using JWT
class ApiController < ApplicationController
  before_action :underscore_params!

  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end

  def logged_in_user
    return unless decoded_token

    user_id = decoded_token[0]['user_id']
    User.find_by(id: user_id)
  end

  private

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    return unless auth_header

    token = auth_header.split(' ')[1]
    # header: { 'Authorization': 'Bearer <token>' }
    begin
      JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
    rescue JWT::DecodeError
      nil
    end
  end

  def logged_in?
    !!logged_in_user
  end

  def underscore_params!
    params.deep_transform_keys!(&:underscore)
  end
end
