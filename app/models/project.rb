# frozen_string_literal: true

# Project model to handle project
class Project < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, :type, :location, :thumbnail
  validates_uniqueness_of :title
end
