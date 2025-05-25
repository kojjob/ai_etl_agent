class CreateSystemSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :system_settings do |t|
      t.string :setting_key
      t.jsonb :setting_value
      t.text :description
      t.boolean :is_sensitive

      t.timestamps
    end
    add_index :system_settings, :setting_key, unique: true
  end
end
