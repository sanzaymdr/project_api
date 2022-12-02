# frozen_string_literal: true

# Serializer for User
class UserSerializer < ActiveModel::Serializer
  attributes :id, :token, :email, :name, :country, :created_at, :updated_at

  def token
    object.encode_token
  end
end
