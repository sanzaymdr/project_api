class CreateContents < ActiveRecord::Migration[7.0]
  def change
    create_table :contents do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
