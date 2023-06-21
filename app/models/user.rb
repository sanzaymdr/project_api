# frozen_string_literal: true

# User model to handle users
class User < ApplicationRecord
  has_secure_password

  validates_presence_of :first_name, :last_name, :email, :password
  validates_uniqueness_of :email

  has_many :projects

  def name
    "#{first_name} #{last_name}".titlecase
  end

  def encode_token
    JWT.encode({ user_id: id }, Rails.application.secrets.secret_key_base.to_s)
  end

  def create_test_auth_header
    { Authorization: "Bearer #{encode_token}" }
  end
end
