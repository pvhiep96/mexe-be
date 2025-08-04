class CreateProductReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :product_reviews do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :rating, null: false
      t.string :title
      t.text :comment
      t.boolean :is_verified_purchase, default: true
      t.boolean :is_approved, default: false

      t.timestamps
    end
  end
end 