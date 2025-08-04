class CreateSettings < ActiveRecord::Migration[7.2]
  def change
    create_table :settings do |t|
      t.string :setting_key, null: false
      t.text :setting_value
      t.string :setting_type, default: 'string'
      t.text :description

      t.timestamps
    end

    add_index :settings, :setting_key, unique: true
  end
end 