class CreateAuditLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :audit_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action
      t.references :entity, polymorphic: true, null: false
      t.jsonb :old_value
      t.jsonb :new_value
      t.string :ip_address

      t.timestamps
    end
  end
end
