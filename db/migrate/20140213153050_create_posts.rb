class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :fb_id
      t.string :type
      t.string :picture
      t.integer :category_id
      t.integer :user_id

      t.timestamps
    end
  end
end
