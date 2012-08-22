class AddLinkToPark < ActiveRecord::Migration
  def change
    add_column :parks, :link, :string
  end
end
