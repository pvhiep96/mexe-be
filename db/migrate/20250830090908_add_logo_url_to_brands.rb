class AddLogoUrlToBrands < ActiveRecord::Migration[7.2]
  def change
    add_column :brands, :logo_url, :string
  end
end
