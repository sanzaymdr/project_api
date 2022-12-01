# frozen_string_literal: true

# Project model to handle project
class Project < ApplicationRecord
  belongs_to :user
  has_many :contents

  validates_presence_of :title, :project_type, :location, :thumbnail
  validates_uniqueness_of :title, scope: :user

  mount_uploader :thumbnail, ThumbnailUploader

  enum project_type: { in_house: 0, external: 1, international: 2 }
end
