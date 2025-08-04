class CreateArticleImages < ActiveRecord::Migration[7.2]
  def change
    create_table :article_images do |t|
      t.references :article, null: false, foreign_key: true
      t.string :image_url, null: false
      t.string :alt_text
      t.string :caption
      t.integer :sort_order, default: 0

      t.timestamps
    end
  end
end 