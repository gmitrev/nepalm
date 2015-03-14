# == Schema Information
#
# Table name: tasks
#
#  id           :integer          not null, primary key
#  name         :string
#  task_list_id :integer
#  completed    :boolean
#  created_at   :datetime
#  updated_at   :datetime
#

class Task < ActiveRecord::Base
  belongs_to :task_list

  def not_completed?
    !completed?
  end

  def complete!
    update_attributes(completed: true, completed_at: Time.now)
  end

  def uncomplete!
    update_column(:completed, false)
  end

  def toggle!
    update_column(:completed, !self.completed?)
  end
end
