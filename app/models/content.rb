# frozen_string_literal: true

# Content model to handle project's content
class Content < ApplicationRecord
  belongs_to :project

  validates_presence_of :title, :body
end
