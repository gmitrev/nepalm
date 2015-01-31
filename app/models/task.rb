class Task < ActiveRecord::Base
  belongs_to :task_list

  def complete!
    update_column(:completed, true)
  end

  def uncomplete!
    update_column(:completed, false)
  end

  def toggle!
    update_column(:completed, !self.completed?)
  end
end
