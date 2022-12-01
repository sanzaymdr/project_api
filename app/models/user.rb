# frozen_string_literal: true

# User model to handle users
class User < ApplicationRecord
  has_secure_password

  validates_presence_of :first_name, :last_name, :email, :password
  validates_uniqueness_of :email

  has_many :projects
end
