class CreateArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :excerpt
      t.text :content, null: false
      t.string :featured_image
      t.string :author, default: 'Mexe Team'
      t.string :category
      t.json :tags
      t.string :status, default: 'draft'
      t.datetime :published_at
      t.integer :view_count, default: 0
      t.string :meta_title
      t.text :meta_description

      t.timestamps
    end

    add_index :articles, :slug, unique: true
  end
end 