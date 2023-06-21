# frozen_string_literal: true

# Serializer for Content
class ContentSerializer < ActiveModel::Serializer
  attributes :id, :project_id, :project_owner_name, :title, :body, :created_at, :updated_at

  def project_owner_name
    object.project.user.name
  end
end
