class CreatePipelineSteps < ActiveRecord::Migration[8.0]
  def change
    create_table :pipeline_steps do |t|
      t.references :pipeline, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :step_type
      t.integer :sequence_order
      t.jsonb :configuration
      t.references :source_connection, null: false, foreign_key: { to_table: :connections }
      t.references :target_connection, null: false, foreign_key: { to_table: :connections }
      t.jsonb :expected_input_schema
      t.jsonb :expected_output_schema
      t.jsonb :ui_position

      t.timestamps
    end
  end
end
