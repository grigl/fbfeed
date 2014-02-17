class RenamePostTypeToStatusType < ActiveRecord::Migration
  def change
    rename_column :posts, :type, :status_type
  end
end

