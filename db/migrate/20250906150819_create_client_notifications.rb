class CreateClientNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :client_notifications do |t|
      t.references :admin_user, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.string :title, null: false
      t.text :message, null: false
      t.string :notification_type, default: 'new_order'
      t.boolean :is_read, default: false
      t.datetime :read_at
      t.json :data
      t.timestamps
    end
    
    add_index :client_notifications, :admin_user_id, name: 'idx_client_notifications_on_admin_user_id'
    add_index :client_notifications, :is_read, name: 'idx_client_notifications_on_is_read'
    add_index :client_notifications, :notification_type, name: 'idx_client_notifications_on_notification_type'
  end
end
