class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.string :session_id
      t.string :role
      t.text :content
      t.string :data_attachment_path
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
