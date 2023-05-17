ActiveAdmin.register User do
  permit_params :name, :email, :role

  filter :name
  filter :role, filters: [:equals]
  filter :email
  filter :created_at

  index do
    id_column
    column :name
    column :email
    column :role
    column :created_at
    column :confirmed_at
    actions
  end

  scope 'Active Users', :active
end
