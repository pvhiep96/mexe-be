ActiveAdmin.register Article do
  permit_params :title, :slug, :excerpt, :content, :featured_image, :author, :category, :tags, 
                :status, :published_at, :view_count, :meta_title, :meta_description

  index do
    selectable_column
    id_column
    column :title
    column :author
    column :category
    column :status
    column :published_at
    column :view_count
    column :created_at
    actions
  end

  filter :title
  filter :author
  filter :category
  filter :status
  filter :published_at
  filter :created_at

  form do |f|
    f.inputs do
      f.input :title
      f.input :slug
      f.input :excerpt
      f.input :content, as: :text
      f.input :featured_image
      f.input :author
      f.input :category
      f.input :tags
      f.input :status
      f.input :published_at
      f.input :meta_title
      f.input :meta_description
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :slug
      row :excerpt
      row :content
      row :featured_image
      row :author
      row :category
      row :tags
      row :status
      row :published_at
      row :view_count
      row :meta_title
      row :meta_description
      row :created_at
      row :updated_at
    end
  end
end
