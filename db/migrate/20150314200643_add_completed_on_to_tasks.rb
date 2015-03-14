class AddCompletedOnToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :completed_at, :datetime

    Task.where(completed: true).each { |r| r.update_column(:completed_at, r.updated_at) }
  end
end
