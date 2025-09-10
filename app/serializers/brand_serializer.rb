class BrandSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :logo

  def logo
    logo_url = object.logo
    logo_url.present? ? logo_url : nil
  end
end
