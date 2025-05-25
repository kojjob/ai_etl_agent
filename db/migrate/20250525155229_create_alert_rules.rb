class CreateAlertRules < ActiveRecord::Migration[8.0]
  def change
    create_table :alert_rules do |t|
      t.string :name
      t.text :description
      t.string :target_entity_type
      t.jsonb :condition
      t.string :severity
      t.jsonb :notification_channels
      t.boolean :is_active

      t.timestamps
    end
  end
end
