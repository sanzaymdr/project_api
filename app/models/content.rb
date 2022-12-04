# frozen_string_literal: true

# Content model to handle project's content
class Content < ApplicationRecord
  belongs_to :project

  validates_presence_of :title, :body
  validates_uniqueness_of :title, scope: :project_id

  def associated_user
    project&.user
  end
end
