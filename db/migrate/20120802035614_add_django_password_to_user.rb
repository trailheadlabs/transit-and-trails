class AddDjangoPasswordToUser < ActiveRecord::Migration
  def change
    add_column :users, :django_password, :string
  end
end
