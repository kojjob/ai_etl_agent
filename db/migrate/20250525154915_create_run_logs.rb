class CreateRunLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :run_logs do |t|
      t.references :pipeline_run, null: false, foreign_key: true
      t.references :pipeline_step_run, null: false, foreign_key: true
      t.datetime :timestamp
      t.string :level
      t.text :message
      t.string :source

      t.timestamps
    end
  end
end
