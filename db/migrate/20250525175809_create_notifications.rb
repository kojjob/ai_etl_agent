class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :alert, null: false, foreign_key: true
      t.string :channel
      t.text :content
      t.string :status
      t.datetime :read_at

      t.timestamps
    end
  end
end
