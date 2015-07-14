class AddTotalFileSizeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :total_file_size, :integer, default: 0
  end
end
