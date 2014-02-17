class AddCreatedTimeAndUpdatedTimeToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :created_time, :string
    add_column :posts, :updated_time, :string
  end
end
