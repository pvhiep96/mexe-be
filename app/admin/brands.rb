ActiveAdmin.register Brand do
  permit_params :name, :slug, :description, :logo, :founded_year, :field, :story, :website, :sort_order, :is_active

  index do
    selectable_column
    id_column
    column :name
    column :slug
    column :founded_year
    column :field
    column :sort_order
    column :is_active
    column :created_at
    actions
  end

  filter :name
  filter :field
  filter :founded_year
  filter :is_active
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :slug
      f.input :description
      f.input :logo
      f.input :founded_year
      f.input :field
      f.input :story
      f.input :website
      f.input :sort_order
      f.input :is_active
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :slug
      row :description
      row :logo
      row :founded_year
      row :field
      row :story
      row :website
      row :sort_order
      row :is_active
      row :created_at
      row :updated_at
    end
  end
end
