class RemoveOwnerTypeFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :owner_type
  end
end
