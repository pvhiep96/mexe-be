ActiveAdmin.register User do
  permit_params :email, :full_name, :phone, :date_of_birth, :gender, :is_active, :is_verified

  index do
    selectable_column
    id_column
    column :email
    column :full_name
    column :phone
    column :is_active
    column :is_verified
    column :created_at
    actions
  end

  filter :email
  filter :full_name
  filter :phone
  filter :is_active
  filter :is_verified
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :full_name
      f.input :phone
      f.input :date_of_birth
      f.input :gender
      f.input :is_active
      f.input :is_verified
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :full_name
      row :phone
      row :date_of_birth
      row :gender
      row :is_active
      row :is_verified
      row :created_at
      row :updated_at
    end
  end
end
