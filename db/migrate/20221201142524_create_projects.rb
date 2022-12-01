class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.string :type
      t.string :location
      t.string :thumbnail
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
