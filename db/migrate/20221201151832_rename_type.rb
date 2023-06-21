class RenameType < ActiveRecord::Migration[7.0]
  def change
    rename_column :projects, :type, :project_type
  end
end
