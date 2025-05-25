class CreateAiSuggestions < ActiveRecord::Migration[8.0]
  def change
    create_table :ai_suggestions do |t|
      t.references :user, null: false, foreign_key: true
      t.uuid :session_id
      t.references :context_entity, polymorphic: true, null: false
      t.text :suggestion_prompt
      t.jsonb :suggestion_content
      t.string :suggestion_type
      t.float :confidence_score
      t.string :status
      t.integer :feedback_rating
      t.text :feedback_text

      t.timestamps
    end
  end
end
