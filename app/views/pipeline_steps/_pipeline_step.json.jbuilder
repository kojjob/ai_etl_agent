json.extract! pipeline_step, :id, :pipeline_id, :name, :description, :step_type, :sequence_order, :configuration, :source_connection_id, :target_connection_id, :expected_input_schema, :expected_output_schema, :ui_position, :created_at, :updated_at
json.url pipeline_step_url(pipeline_step, format: :json)
