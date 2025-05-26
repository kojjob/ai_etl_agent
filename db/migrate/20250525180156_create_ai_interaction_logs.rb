class CreateAiInteractionLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :ai_interaction_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.uuid :session_id
      t.text :user_query
      t.text :ai_response
      t.string :interaction_type
      t.references :context_entity, polymorphic: true, null: false

      t.timestamps
    end
  end
end
