class AddMessageToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :message, :string
  end
end
