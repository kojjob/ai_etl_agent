class CreatePipelines < ActiveRecord::Migration[8.0]
  def change
    create_table :pipelines do |t|
      t.string :name
      t.text :description
      t.references :created_by_user, null: false, foreign_key: { to_table: :users }, null: false
      t.references :project, null: false, foreign_key: true
      t.integer :version
      t.string :status
      t.jsonb :tags
      t.jsonb :ai_assisted_design_details

      t.timestamps
    end
  end
end
