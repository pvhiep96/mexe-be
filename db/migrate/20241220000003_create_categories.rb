class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :image
      t.references :parent, null: true, foreign_key: { to_table: :categories }
      t.integer :sort_order, default: 0
      t.boolean :is_active, default: true
      t.string :meta_title
      t.text :meta_description

      t.timestamps
    end

    add_index :categories, :slug, unique: true
  end
end 