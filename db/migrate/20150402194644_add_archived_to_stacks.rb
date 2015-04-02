class AddArchivedToStacks < ActiveRecord::Migration
  def change
    add_column :stacks, :archived, :boolean, default: false
  end
end
