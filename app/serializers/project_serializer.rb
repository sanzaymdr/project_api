# frozen_string_literal: true

# Serializer for Project
class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :thumbnail, :description, :location, :project_type, :owner_name, :created_at, :updated_at

  attribute :owner_name, unless: :exclude_owner

  def exclude_owner
    @instance_options[:exclude_owner]
  end

  def owner_name
    object.user.name
  end

  def thumbnail
    object.thumbnail.url
  end

  def location
    object.location.titlecase
  end
end
