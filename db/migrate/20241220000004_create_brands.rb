class CreateBrands < ActiveRecord::Migration[7.2]
  def change
    create_table :brands do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :logo
      t.text :description
      t.integer :founded_year
      t.string :field
      t.text :story
      t.string :website
      t.boolean :is_active, default: true
      t.integer :sort_order, default: 0

      t.timestamps
    end

    add_index :brands, :slug, unique: true
  end
end 