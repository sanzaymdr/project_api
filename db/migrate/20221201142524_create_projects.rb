class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description
      t.string :type, null: false
      t.string :location, null: false
      t.string :thumbnail, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
