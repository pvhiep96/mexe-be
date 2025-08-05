ActiveAdmin.register Category do
  permit_params :name, :slug, :description, :parent_id, :sort_order, :is_active, :meta_title, :meta_description

  index do
    selectable_column
    id_column
    column :name
    column :slug
    column :parent
    column :sort_order
    column :is_active
    column :created_at
    actions
  end

  filter :name
  filter :parent
  filter :is_active
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :slug
      f.input :description
      f.input :parent
      f.input :sort_order
      f.input :is_active
      f.input :meta_title
      f.input :meta_description
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :slug
      row :description
      row :parent
      row :sort_order
      row :is_active
      row :meta_title
      row :meta_description
      row :created_at
      row :updated_at
    end
  end
end
