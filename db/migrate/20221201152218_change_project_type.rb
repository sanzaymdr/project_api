class ChangeProjectType < ActiveRecord::Migration[7.0]
  def change
    change_column :projects, :project_type, :integer, using: 'project_type::integer'
  end
end
