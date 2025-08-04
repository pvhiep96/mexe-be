class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :message, null: false
      t.string :type, null: false
      t.boolean :is_read, default: false
      t.json :data

      t.timestamps
    end
  end
end 